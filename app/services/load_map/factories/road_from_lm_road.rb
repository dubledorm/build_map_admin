# frozen_string_literal: true
require 'csv'

# Модуль группирует всё необходимое для загрузки карт и маршрутов помещений
module LoadMap
  module Factories
    # Фабрика для создания Road из LoadMap::Road
    class RoadFromLmRoad
      def self.build(load_map_road, array_of_ids)
        point1_id = array_of_ids.find { |pair| pair[:target_id] == load_map_road.start_id }[:point_ar_id]
        point2_id = array_of_ids.find { |pair| pair[:target_id] == load_map_road.end_id }[:point_ar_id]
        ::Road.new(point1_id:, point2_id:, weight: load_map_road.weight)
      end
    end
  end
end

