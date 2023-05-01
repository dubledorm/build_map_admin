# frozen_string_literal: true

# Модуль группирует всё необходимое для загрузки карт и маршрутов помещений
module LoadMap
  # Класс для обработки тэга circle
  class Point < BaseTag

    attr_reader :x1, :y1, :id, :r, :length, :content

    REG_EXP_X1 = /cx="(?<x1>[^"]*)"/.freeze
    REG_EXP_Y1 = /cy="(?<y1>[^"]*)"/.freeze
    REG_EXP_R = /r="(?<r>[^"]*)"/.freeze
    REG_EXP_ID = /id="(?<id>[^"]*)"/.freeze
    REG_EXP_FIND_CIRCLE = %r{^\s*<circle\s*(?<content>[^/]*)/>}.freeze
    UNKNOWN_LENGTH_MESSAGE = 'Перед вызовом length должна быть вызвана функция tag_str_parse'

    def self.str_start_with_me?(str)
      str =~ REG_EXP_FIND_CIRCLE
    end

    def inside_of_me?(point_x, point_y)
      l = x1 - point_x
      h = y1 - point_y
      g = Math.sqrt(l * l + h * h)
      g < r
    end

    protected

    def tag_str_parse(str)
      m = str.match(REG_EXP_FIND_CIRCLE)
      raise LoadMap::SvgParserError, "Строка #{str} должна соответствовать: #{REG_EXP_FIND_CIRCLE}" unless m

      @content = m[:content]
      @length = m.end(0)
      parse_coordinates(@content)
    end

    private

    def parse_coordinates(tag_str)
      @x1 = normalize_coordinate(tag_str.match(REG_EXP_X1)[:x1])
      @y1 = normalize_coordinate(tag_str.match(REG_EXP_Y1)[:y1])
      @r = normalize_coordinate(tag_str.match(REG_EXP_R)[:r])
      @id = tag_str.match(REG_EXP_ID)[:id]
    end
  end
end
