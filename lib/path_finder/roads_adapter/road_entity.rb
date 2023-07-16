# frozen_string_literal: true

module RoadsAdapter
  # Класс, для хранения маршрута в универсальном формате. Предоставляет атрибуты, позволяющие работать с ним классу
  # BaseRoadsAdapter.
  class RoadEntity
    attr_accessor :point1_id, :point2_id, :weight, :source_object, :source_id
    attr_reader :point1_index, :point2_index

    def fill_points_indexes(point1_index, point2_index)
      @point1_index = point1_index
      @point2_index = point2_index
    end
  end
end
