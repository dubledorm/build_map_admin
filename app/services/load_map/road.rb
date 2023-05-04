# frozen_string_literal: true

# Модуль группирует всё необходимое для загрузки карт и маршрутов помещений
module LoadMap
  # Класс для дополнения класса line идентификаторами точки начала и точки конца дуги
  class Road

    attr_reader :start_id, :end_id, :line

    delegate :weight, to: :line

    def initialize(line, start_id, end_id)
      @line = line
      @start_id = start_id
      @end_id = end_id
    end
  end
end
