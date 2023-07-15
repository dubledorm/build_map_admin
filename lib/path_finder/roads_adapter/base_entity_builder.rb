# frozen_string_literal: true

module RoadsAdapter
  # Класс, который переводит road из формата БД в формат entity.
  # Имеет одну функцию, которая возращает
  class BaseEntityBuilder
    attr_reader :point1_entity, :point2_entity, :road_entity

    def initialize(road)
      @road = road
      @point1_entity = build_point1_entity
      @point2_entity = build_point2_entity
      @road_entity = build_road_entity
    end

    def build_point1_entity
      raise NotImplementedError
    end

    def build_point2_entity
      raise NotImplementedError
    end

    def build_road_entity
      raise NotImplementedError
    end
  end
end
