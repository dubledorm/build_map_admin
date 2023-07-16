# frozen_string_literal: true

require 'path_finder/roads_adapter/base_entity_builder'
require 'path_finder/roads_adapter/point_entity'
require 'path_finder/roads_adapter/road_entity'

module Core
  # Конвертер для преобразования записей БД (roads, points) к формату Entity для работы PathFinder
  class ActiveRecordEntityBuilder < RoadsAdapter::BaseEntityBuilder
    def build_point1_entity
      RoadsAdapter::PointEntity.new(@road.point1_id)
    end

    def build_point2_entity
      RoadsAdapter::PointEntity.new(@road.point2_id)
    end

    def build_road_entity
      road_entity = RoadsAdapter::RoadEntity.new
      road_entity.point1_id = @road.point1_id
      road_entity.point2_id = @road.point2_id
      road_entity.weight = @road.weight
      road_entity.source_id = @road.id
      road_entity.source_object = @road
      road_entity
    end
  end
end
