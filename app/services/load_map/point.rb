# frozen_string_literal: true

# Модуль группирует всё необходимое для загрузки карт и маршрутов помещений
module LoadMap
  # Найденный в svg файле тег ellipse или point
  class Point < BaseTag

    attr_reader :x1, :y1, :id, :r

    REG_EXP_X1 = /cx="(?<x1>[^"]*)"/.freeze
    REG_EXP_Y1 = /cy="(?<y1>[^"]*)"/.freeze
    REG_EXP_R = /r="(?<r>[^"]*)"/.freeze
    REG_EXP_ID = /id="(?<id>[^"]*)"/.freeze

    protected

    def tag_str_parse(tag_str)
      @x1 = normalize_coordinate(tag_str.match(REG_EXP_X1)[:x1])
      @y1 = normalize_coordinate(tag_str.match(REG_EXP_Y1)[:y1])
      @r = normalize_coordinate(tag_str.match(REG_EXP_R)[:r])
      @id = tag_str.match(REG_EXP_ID)[:id]
    end
  end
end
