# frozen_string_literal: true

# Класс для сохранения найденных маршрутов
class PathStorage
  attr_reader :paths

  def initialize(roads_adapter)
    @paths = Enumerator.produce { [] }.take(dimension) # Сюда сохраняем маршруты
    @roads_adapter = roads_adapter # Маршруты, среди них будем искать по точкам и индексу
  end

  def add(road_index, target_index)
    @paths[target_index] << road_index
  end

  def replace(target_index, new_value)
    paths[target_index] = new_value
  end

  private

  def dimension
    @dimension ||= @roads_adapter.point_entities.count
  end
end
