# frozen_string_literal: true

require 'path_finder/path_finder'
require 'path_finder/roads_adapter/roads_adapter'

module Core
  module Routes
    module Services
      # Найти маршрут между двумя точками
      class FindPath
        EXCEPT_FIELDS = %i[created_at updated_at organization_id].freeze
        ROAD_TYPE_TO_SPEAKER = { 'road' => Core::Routes::Services::PathSpeaker,
                                 nil => Core::Routes::Services::PathSpeaker,
                                 'staircase' => Core::Routes::Services::VerticalPathSpeaker}.freeze

        def initialize(building_id, start_point_id, end_point_id)
          @building_id = building_id
          @start_point_id = start_point_id
          @end_point_id = end_point_id
        end

        def find
          init
          point_and_weight_array = build_point_and_weight_array(build_roads_fiber)
          points_hash = build_points_hash(point_and_weight_array)
          result = point_and_weight_array.map do |point_and_weight|
            point_and_weight[:point] = points_hash.find { |point| point[:id] == point_and_weight[:point_id] }
            point_and_weight
          end
          Core::Routes::Dto::FindPathResponse.success(aggregate_steps(add_legend(result)))
        rescue StandardError => e
          Core::Routes::Dto::FindPathResponse.error(e.message)
        end

        private

        def init
          @start_point = Point.find(@start_point_id)
          if @start_point.label_direction == 'none'
            raise StandardError, "Для точки #{@start_point.id} не указано направление этикетки QR кода. Не могу построить описание маршрута"
          end

          @end_point = Point.find(@end_point_id)
          validate_arguments!
        end

        def add_legend(point_and_weight_array)
          current_direction = @start_point.label_direction.to_sym

          point_and_weight_array.each_with_object([]) do |point_end_weight, queue|
            queue << point_end_weight
            next unless queue.length > 1

            current_direction = fill_legend(queue[0], queue[1], current_direction)
            queue.shift
          end
          fill_legend(point_and_weight_array.last, nil, current_direction)
          point_and_weight_array
        end

        def fill_legend(point_and_weight1, point_and_weight2, current_direction)
          path_speaker = ROAD_TYPE_TO_SPEAKER[point_and_weight1.dig(:road, :road_type)]
                         .new(point_and_weight1[:point], point_and_weight2&.dig(:point), point_and_weight1[:road],
                              current_direction, BuildingPart.find(point_and_weight1[:point][:building_part_id])
                                                               .map_scale)

          point_and_weight1[:legend] = path_speaker.legend
          point_and_weight1[:direction] = path_speaker.user_direction
          point_and_weight1[:weight] = path_speaker.length_m
          point_and_weight1[:map_direction] = path_speaker.map_direction
          path_speaker.map_direction
        end

        def aggregate_steps(point_and_weight_array)
          point_and_weight_array.each_with_object([]) do |point_end_weight, queue|
            if queue.empty? || point_end_weight[:direction] != :forward || queue[-1][:direction] != :forward
              queue << point_end_weight
              next
            end

            queue[-1][:weight] += point_end_weight[:weight]
            queue[-1][:legend] = PathSpeaker.build_without_map_scale(queue[-1][:point], point_end_weight[:point],
                                                                     queue[-1][:weight], queue[-1][:map_direction])
                                            .legend
          end
        end

        def build_points_hash(point_and_weight_array)
          points_ids = point_and_weight_array.map { |point_and_weight| point_and_weight[:point_id] }.uniq
          Point.where(id: points_ids).map { |point| point.as_json(except: EXCEPT_FIELDS).symbolize_keys }
        end

        # Вернуть в правильном порядке дуги
        def build_roads_fiber
          roads_ids = find_road_ids
          if roads_ids.empty?
            raise StandardError, "Не могу найти маршрут от точки #{@start_point_id} до точки #{@end_point_id}"
          end

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
          building = @start_point.building
          path_finder = PathFinder.new(RoadsAdapter::RoadsAdapter.new(building.roads, ActiveRecordEntityBuilder))
          path_finder.find(@start_point.id, @end_point.id)
        end

        # Вернуть в правильном порядке точки и вес дуги
        def build_point_and_weight_array(roads_fiber)
          current_point_id = @start_point_id
          point_and_weight_array = []
          until (road_hash = roads_fiber.resume).nil?
            first_point_id, next_point_id = select_point(current_point_id, road_hash)
            point_and_weight_array << { point_id: first_point_id, weight: road_hash[:weight],
                                        road: road_hash }
            current_point_id = next_point_id
          end
          point_and_weight_array << { point_id: current_point_id, weight: 0, road: nil }
        end

        def validate_arguments!
          unless @building_id == @start_point.building.id
            raise ArgumentError, "Точка с id = #{@start_point.id} не принадлежит зданию с id = #{@building_id}"
          end

          return if @building_id == @end_point.building.id

          raise ArgumentError, "Точка с id = #{@end_point.id} не принадлежит зданию с id = #{@building_id}"
        end

        def select_point(current_point_id, route)
          return [route[:point1_id], route[:point2_id]] if route[:point1_id] == current_point_id

          [route[:point2_id], route[:point1_id]]
        end
      end
    end
  end
end
