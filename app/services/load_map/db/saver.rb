# frozen_string_literal: true
require 'csv'

# Модуль группирует всё необходимое для загрузки карт и маршрутов помещений
module LoadMap
  module Db
    # Записать Targets и Roads в базу данных
    class Saver
      attr_reader :building_part_id

      def initialize(building_part_id)
        @building_part_id = building_part_id
      end

      def save(load_map_roads, targets)
        BuildingPart.transaction do
          building_part = BuildingPart.find(@building_part_id)
          building_part.roads.clear
          building_part.points.clear

          array_of_ids = save_targets(building_part, targets)
          save_roads(building_part, load_map_roads, array_of_ids)
        end
      end

      private

      def save_targets(building_part, targets)
        targets.inject([]) do |result, target|
          point = LoadMap::Factories::PointFromTarget.build(target)
          building_part.points << point
          result << { point_ar_id: point.id, target_id: target.id }
        end
      end

      def save_roads(building_part, load_map_roads, array_of_ids)
        building_part.roads << load_map_roads.map do |load_map_road|
          LoadMap::Factories::RoadFromLmRoad.build(load_map_road, array_of_ids)
        end
      end
    end
  end
end

