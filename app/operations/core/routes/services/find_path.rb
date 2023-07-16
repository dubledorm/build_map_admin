# frozen_string_literal: true

require 'path_finder/path_finder'
require 'path_finder/roads_adapter/roads_adapter'

module Core
  module Routes
    module Services
      # Найти маршрут между двумя точками
      class FindPath

        def initialize(building_id, start_point_id, end_point_id)
          @building_id = building_id
          @start_point = Point.find(start_point_id)
          @end_point = Point.find(end_point_id)
          validate_arguments!
        rescue ActiveRecord::RecordNotFound => e
          raise ArgumentError, e.message
        end

        def find
          building_part = @start_point.building_part
          path_finder = PathFinder.new(RoadsAdapter::RoadsAdapter.new(building_part.roads, ActiveRecordEntityBuilder))
          roads_ids = path_finder.find(@start_point.id, @end_point.id)
          Road.where(id: roads_ids)
        end

        private

        def validate_arguments!
          unless @building_id == @start_point.building.id
            raise ArgumentError, "Точка с id = #{@start_point} не принадлежит зданию с id = #{@building_id}"
          end

          return if @building_id == @end_point.building.id

          raise ArgumentError, "Точка с id = #{@end_point} не принадлежит зданию с id = #{@building_id}"
        end
      end
    end
  end
end
