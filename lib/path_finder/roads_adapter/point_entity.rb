# frozen_string_literal: true


module RoadsAdapter
  # Класс, для хранения точки в универсальном формате. Предоставляет функции, позволяющие работать с ним классу
  # BaseRoadsAdapter.
  class PointEntity
    attr_reader :source_id

    def initialize(source_id)
      @source_id = source_id
    end

    # Вернуть Id исходного объекта
    def id
      @source_id
    end
  end
end
