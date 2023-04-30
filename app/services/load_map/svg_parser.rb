# frozen_string_literal: true

# Модуль группирует всё необходимое для загрузки карт и маршрутов помещений
module LoadMap

  # сервис для разбора svg файла и получения из него списка маршрутов и списка точек.
  class SvgParser
    REG_EXP_FIND_LAYER = /<g class="layer">[^<]*<title>Roads<\/title>/.freeze
    REG_EXP_FIND_LINE = /^\s*<line\s*(?<content>[^\/]*)\/>/.freeze
    REG_EXP_FIND_CIRCLE = /^\s*<circle\s*(?<content>[^\/]*)\/>/.freeze
    REG_EXP_FIND_END = /^\s*<\/g>/.freeze

    attr_reader :lines, :points

    def initialize(svg_string)
      @svg_string = svg_string.gsub("\n", '')
      @lines = @points = @tags = []

      @parser = Fiber.new do |remainder_str|
        current_tag = find_layer_tag(remainder_str)
        loop do
          Fiber.yield current_tag
          remainder_str = remainder_str[current_tag.length..-1]
          current_tag = find_circle_or_line_tag(remainder_str)
        end
      end
    end

    def parse
      if @parser.resume(@svg_string)&.tag_type != :layer
        raise StandardError, 'В переданном файле отсутсвует уровень \'Roads\''
      end
      current_tag = @parser.resume
      while current_tag
        tag_processed(current_tag)
        current_tag = @parser.resume
      end

      tags_select_by_type
      self
    rescue StandardError => e
      raise SvgParserError, e.message
    end

    private

    def tag_processed(current_tag)
      if current_tag.tag_type == :unknown
        raise StandardError, "На уровне 'Roads' в svg файле встретился неизвестный тег #{current_tag.content}"
      end

      @tags << TagFactory.build(current_tag)
    end

    def find_layer_tag(remainder_str)
      m = remainder_str.match(REG_EXP_FIND_LAYER)
      return SvgTag.new(tag_type: :unknown) unless m

      SvgTag.new(tag_type: :layer, length: m.end(0))
    end

    def find_circle_or_line_tag(remainder_str)
      m = remainder_str.match(REG_EXP_FIND_LINE)
      return SvgTag.new(tag_type: :line, content: m[:content], length: m.end(0)) if m

      m = remainder_str.match(REG_EXP_FIND_CIRCLE)
      return SvgTag.new(tag_type: :circle, content: m[:content], length: m.end(0)) if m

      m = remainder_str.match(REG_EXP_FIND_END)
      return nil if m

      SvgTag.new(tag_type: :unknown)
    end

    def tags_select_by_type
      @points = @tags.select { |tag| tag.is_a?(LoadMap::Point) } | []
      @lines = @tags.select { |tag| tag.is_a?(LoadMap::Line) } | []
    end
  end
end
