# frozen_string_literal: true

# Класс для сохранения найденных маршрутов
class PathStorage
  attr_reader :paths

  def initialize(roads_adapter)
    @roads_adapter = roads_adapter # Маршруты, среди них будем искать по точкам и индексу
    @paths = Enumerator.produce { [] }.take(dimension) # Сюда сохраняем маршруты
  end

  # добавить индекс дуги в конец маршрута с индексом target_index
  def add(road_index, target_index)
    @paths[target_index] << road_index
  end

  # заменить маршрут в точку target_index на новый маршрут new_path
  def replace(target_index, new_path)
    paths[target_index] = new_path.dup
  end

  private

  def dimension
    @dimension ||= @roads_adapter.point_entities.count
  end
end
