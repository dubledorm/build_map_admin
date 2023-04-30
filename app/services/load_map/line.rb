# frozen_string_literal: true

# Модуль группирует всё необходимое для загрузки карт и маршрутов помещений
module LoadMap
  # Найденный в svg файле тег line
  class Line < BaseTag

    attr_reader :x1, :y1, :x2, :y2

    REG_EXP_X1 = /x1="(?<x1>[^"]*)"/.freeze
    REG_EXP_X2 = /x2="(?<x2>[^"]*)"/.freeze
    REG_EXP_Y1 = /y1="(?<y1>[^"]*)"/.freeze
    REG_EXP_Y2 = /y2="(?<y2>[^"]*)"/.freeze

    def weight

    end

    protected

    def tag_str_parse(tag_str)
      @x1 = normalize_coordinate(tag_str.match(REG_EXP_X1)[:x1])
      @x2 = normalize_coordinate(tag_str.match(REG_EXP_X2)[:x2])
      @y1 = normalize_coordinate(tag_str.match(REG_EXP_Y1)[:y1])
      @y2 = normalize_coordinate(tag_str.match(REG_EXP_Y2)[:y2])
    end
  end
end
