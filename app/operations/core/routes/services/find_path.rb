# frozen_string_literal: true

require 'path_finder/path_finder'
require 'path_finder/roads_adapter/roads_adapter'

module Core
  module Routes
    module Services
      # Найти маршрут между двумя точками
      class FindPath
        EXCEPT_FIELDS = %i[created_at updated_at organization_id building_part_id].freeze

        def initialize(building_id, start_point_id, end_point_id)
          @building_id = building_id
          @start_point_id = start_point_id
          @end_point_id = end_point_id
        end

        def find
          init
          point_and_weight_array = build_point_and_weight_array(build_roads_fiber)
          points_hash = build_points_hash(point_and_weight_array)
          point_and_weight_array.map do |point_and_weight|
            point_and_weight[:point] = points_hash.find { |point| point[:id] == point_and_weight[:point_id] }
            point_and_weight
          end
        rescue StandardError => e
          Core::Routes::Dto::FindPathResponse.error(e.message)
        end

        private

        def init
          @start_point = Point.find(@start_point_id)
          @end_point = Point.find(@end_point_id)
          validate_arguments!
        end

        def build_points_hash(point_and_weight_array)
          points_ids = point_and_weight_array.map { |point_and_weight| point_and_weight[:point_id] }.uniq
          Point.where(id: points_ids).map { |point| point.as_json(except: EXCEPT_FIELDS).symbolize_keys }
        end

        # Вернуть в правильном порядке дуги
        def build_roads_fiber
          roads_ids = find_road_ids
          Fiber.new do
            roads = Road.where(id: roads_ids).map { |road| road.as_json(except: EXCEPT_FIELDS).symbolize_keys }
            index = 0
            loop do
              Fiber.yield roads_ids.size <= index ? nil : roads.find { |road| road[:id] == roads_ids[index] }
              index += 1
            end
          end
        end

        def find_road_ids
          building_part = @start_point.building_part
          path_finder = PathFinder.new(RoadsAdapter::RoadsAdapter.new(building_part.roads, ActiveRecordEntityBuilder))
          path_finder.find(@start_point.id, @end_point.id)
        end

        # Вернуть в правильном порядке точки и вес дуги
        def build_point_and_weight_array(roads_fiber)
          current_point_id = @start_point_id
          point_and_weight_array = []
          until (road_hash = roads_fiber.resume).nil?
            first_point_id, next_point_id = select_point(current_point_id, road_hash)
            point_and_weight_array << { point_id: first_point_id, weight: road_hash[:weight] }
            current_point_id = next_point_id
          end
          point_and_weight_array << { point_id: current_point_id, weight: 0 }
        end

        def validate_arguments!
          unless @building_id == @start_point.building.id
            raise ArgumentError, "Точка с id = #{@start_point} не принадлежит зданию с id = #{@building_id}"
          end

          return if @building_id == @end_point.building.id

          raise ArgumentError, "Точка с id = #{@end_point} не принадлежит зданию с id = #{@building_id}"
        end

        def select_point(current_point_id, route)
          return [route[:point1_id], route[:point2_id]] if route[:point1_id] == current_point_id

          [route[:point2_id], route[:point1_id]]
        end
      end
    end
  end
end
