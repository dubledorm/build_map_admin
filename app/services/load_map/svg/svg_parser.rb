# frozen_string_literal: true

# Модуль группирует всё необходимое для загрузки карт и маршрутов помещений
module LoadMap

  module Svg
    # сервис для разбора svg файла и получения из него списка линий и списка точек.
    # В конструктор передаётся прочитанный в строку svg файл, содержащий уровень, помеченный как
    # REG_EXP_FIND_LAYER
    # В этом уровне, до достижения его конца REG_EXP_FIND_END будут искаться теги, списко которых настраивается в
    # массиве known_tag_classes, также передаваемой через параметр.
    # Результатом работы функции parse будет заполненный hash result, где в качестве ключей используются названия классов
    # найденных тегов, а в качестве значений - массив экземпляров классов, содержащих значения
    #
    # Пример запуска:
    # svg_parser = SvgParser.new(File.open(@source_svg_path, 'r').read, [LoadMap::Line, LoadMap::Point]).parse
    #
    # Пример использования результата
    # svg_parser.result['LoadMap::Line'][1]
    class SvgParser
      ROADS_LAYER_NAME = Settings.svg_file.roads_layer_name
      REG_EXP_FIND_LAYER = Regexp.new("<g class=\"layer\">[^<]*<title>#{ROADS_LAYER_NAME}</title>").freeze
      REG_EXP_FIND_END = %r{^\s*</g>}

      ROADS_NOT_EXIST_MESSAGE = -> { I18n.t('load_map.svg_parser.roads_not_exists_message', layer: ROADS_LAYER_NAME) }
      UNKNOWN_TAG_MESSAGE = lambda { |current_tag|
        I18n.t('load_map.svg_parser.unknown_tag_message', layer: ROADS_LAYER_NAME, tag: current_tag.content)
      }

      attr_reader :result

      def initialize(svg_string, known_tag_classes)
        @svg_string = svg_string.gsub("\n", '')
        @result = {}
        @known_tag_classes = known_tag_classes
        @parser = build_parser
      end

      def parse
        start_pos_content = start_content_of_layer_tag(@svg_string)
        raise SvgParserError, ROADS_NOT_EXIST_MESSAGE.call unless start_pos_content

        read_tags_in_layer_str(@svg_string[start_pos_content..])
        self
      end

      private

      def read_tags_in_layer_str(layer_str)
        current_tag = @parser.resume(layer_str)

        while current_tag
          raise StandardError, UNKNOWN_TAG_MESSAGE.call(current_tag) if current_tag.is_a?(LoadMap::Svg::UnknownTag)

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
end
