# frozen_string_literal: true

# Модуль группирует всё необходимое для загрузки карт и маршрутов помещений
module LoadMap
  # Найденный в svg файле тег line
  class Line < BaseTag

    attr_reader :x1, :y1, :x2, :y2

    def initialize(tag_str)

    end

    def weight

    end

    protected

    def tag_str_parse(_tag_str)
      throw NotImplementedError
    end
  end
end
