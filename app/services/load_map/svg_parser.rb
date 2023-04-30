# frozen_string_literal: true

# Модуль группирует всё необходимое для загрузки карт и маршрутов помещений
module LoadMap

  # сервис для разбора svg файла и получения из него списка линий и списка точек.
  class SvgParser
    REG_EXP_FIND_LAYER = /<g class="layer">[^<]*<title>Roads<\/title>/.freeze
    REG_EXP_FIND_END = /^\s*<\/g>/.freeze

    ROADS_NOT_EXIST_MESSAGE = 'В переданном файле отсутсвует уровень \'Roads\''
    UNKNOWN_TAG_MESSAGE = lambda { |current_tag|
      "На уровне 'Roads' в svg файле встретился неизвестный тег #{current_tag.content}"
    }

    attr_reader :result, :known_tag_classes

    def initialize(svg_string)
      @svg_string = svg_string.gsub("\n", '')
      @result = {}
      @known_tag_classes = LoadMap.known_tag_classes
      @parser = build_parser
    end

    def parse
      start_pos_content = start_content_of_layer_tag(@svg_string)
      raise SvgParserError, ROADS_NOT_EXIST_MESSAGE unless start_pos_content

      read_tags_in_layer_str(@svg_string[start_pos_content..])
      self
    end

    private

    def read_tags_in_layer_str(layer_str)
      current_tag = @parser.resume(layer_str)

      while current_tag
        raise StandardError, UNKNOWN_TAG_MESSAGE.call(current_tag) if current_tag.is_a?(LoadMap::UnknownTag)

        add_to_result(current_tag)
        current_tag = @parser.resume
      end

      self
    rescue StandardError => e
      raise SvgParserError, e.message
    end

    def build_parser
      Fiber.new do |remainder_str|
        current_tag = find_next_tag(remainder_str)
        loop do
          Fiber.yield current_tag
          remainder_str = remainder_str[current_tag.length..]
          current_tag = find_next_tag(remainder_str)
        end
      end
    end

    def add_to_result(current_tag)
      @result[current_tag.class.name] ||= []
      @result[current_tag.class.name] << current_tag
    end

    def start_content_of_layer_tag(remainder_str)
      m = remainder_str.match(REG_EXP_FIND_LAYER)
      return nil unless m

      m.end(0)
    end

    def find_next_tag(remainder_str)
      @known_tag_classes.each do |known_tag_class|
        return known_tag_class.new(remainder_str) if known_tag_class.str_start_with_me?(remainder_str)
      end

      return nil if remainder_str =~ REG_EXP_FIND_END

      UnknownTag.new(remainder_str)
    end
  end
end
