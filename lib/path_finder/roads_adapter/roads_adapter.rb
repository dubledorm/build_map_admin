# frozen_string_literal: true


module RoadsAdapter
  # Класс, скрывающий реализацию хранения точек и маршрутов и предоставляющий возможность работать с ними не по
  # идентификаторам а по индексам
  class RoadsAdapter
    attr_reader :road_entities, :point_entities # два массива, содержащие точки и маршруты в универсальном формате

    def initialize(roads, entity_builder_class)
      @entity_builder_class = entity_builder_class
      @point_entities = []
      @road_entities = []
      roads.each do |road|
        entity = entity_builder_class.new(road)
        add_points(entity.point1_entity, entity.point2_entity)
        @road_entities << fill_points_index(entity.road_entity)
      end
    end

    # Найти индекс точки по переданному идентификатору
    def find_point_index(point_id)
      point_entities.each_with_index do |point_entity, index|
        return index if point_entity.id == point_id
      end

      raise StandardError, "Точка с id - #{point_id} не принадлежит ни одной дуге"
    end

    # Найти дугу по индексу двух точек и весу. Вернуть её индекс
    def find_road_index(start_index, end_index, weight)
      road_entities.each_with_index do |road_entity, index|
        if road_entity.weight == weight &&
           ((road_entity.point1_index == start_index && road_entity.point2_index == end_index) ||
            (road_entity.point1_index == end_index && road_entity.point2_index == start_index))
          return index
        end
      end

      raise StandardError,
            "Не могу найти дугу с параметрами start_index - #{start_index}, end_index #{end_index}, weight #{weight}"
    end

    # Вернуть точку по индексу.
    # Используется для обратного преобразования
    def point_entity(index)
      point_entities[index]
    end

    # Вернуть дугу по индексу.
    # Используется для обратного преобразования
    def road(index)
      road_entities[index].source_object
    end

    # Вернуть id дуги по индексу.
    def road_id(index)
      road_entities[index].source_id
    end

    private

    def add_points(point1_entity, point2_entity)
      [point1_entity, point2_entity].each do |new_entity|
        next if @point_entities.any? { |point_entity| point_entity.id == new_entity.id }

        @point_entities << new_entity
      end
    end

    def fill_points_index(road_entity)
      point1_index = @point_entities.find_index { |point_entity| point_entity.id == road_entity.point1_id }
      point2_index = @point_entities.find_index { |point_entity| point_entity.id == road_entity.point2_id }
      road_entity.fill_points_indexes(point1_index, point2_index)
      road_entity
    end
  end
end
