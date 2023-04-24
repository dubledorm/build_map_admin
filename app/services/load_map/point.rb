# frozen_string_literal: true

# Модуль группирует всё необходимое для загрузки карт и маршрутов помещений
module LoadMap
  # Найденный в svg файле тег ellipse или point
  class Point < BaseTag

    attr_reader :x1, :y1, :id

    def initialize(tag_str)

    end

    protected

    def tag_str_parse(_tag_str)
      throw NotImplementedError
    end
  end
end
