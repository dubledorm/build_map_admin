# frozen_string_literal: true

# Модуль группирует всё необходимое для загрузки карт и маршрутов помещений
module LoadMap
  #  # Класс для обработки тэга line
  class Line < BaseTag

    attr_reader :x1, :y1, :x2, :y2, :weight, :length, :content

    REG_EXP_FIND_LINE = %r{^\s*<line\s*(?<content>[^/]*)/>}.freeze
    REG_EXP_X1 = /x1="(?<x1>[^"]*)"/.freeze
    REG_EXP_X2 = /x2="(?<x2>[^"]*)"/.freeze
    REG_EXP_Y1 = /y1="(?<y1>[^"]*)"/.freeze
    REG_EXP_Y2 = /y2="(?<y2>[^"]*)"/.freeze

    def self.str_start_with_me?(str)
      str =~ REG_EXP_FIND_LINE
    end

    protected

    def tag_str_parse(str)
      m = str.match(REG_EXP_FIND_LINE)
      raise LoadMap::SvgParserError, "Строка #{str} должна соответствовать: #{REG_EXP_FIND_LINE}" unless m

      @content = m[:content]
      @length = m.end(0)
      parse_coordinates(@content)
      @weight = calc_weight
    end

    private

    def parse_coordinates(tag_str)
      @x1 = normalize_coordinate(tag_str.match(REG_EXP_X1)[:x1])
      @x2 = normalize_coordinate(tag_str.match(REG_EXP_X2)[:x2])
      @y1 = normalize_coordinate(tag_str.match(REG_EXP_Y1)[:y1])
      @y2 = normalize_coordinate(tag_str.match(REG_EXP_Y2)[:y2])
    end

    def calc_weight
      l = x1 - x2
      h = y1 - y2
      g = Math.sqrt(l * l + h * h)
      g.to_i
    end
  end
end
