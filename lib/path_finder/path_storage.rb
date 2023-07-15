# frozen_string_literal: true

# Класс для сохранения найденных маршрутов
class PathStorage
  attr_reader :paths

  def initialize(roads, points_enumerator)
    @points_enumerator = points_enumerator # Преобразователь от индексов к id
    @paths = Enumerator.produce { [] }.take(dimension) # Сюда сохраняем маршруты
    @roads = roads # Маршруты, среди них будем искать по точкам и индексу
  end

  def add(start_index, end_index, weight, target_index)
    @paths[target_index] << find_road(@points_enumerator[start_index], @points_enumerator[end_index], weight)
  end

  def find_road(start_id, end_id, weight)
    road = @roads.select do |road|
      road.weight == weight &&
        (road.point1_id == start_id && road.point2_id == end_id) ||
        (road.point1_id == end_id && road.point2_id == start_id)
    end.first

    return road if road

    throw StandardError, "Не могу найти дугу с параметрами start_id - #{start_id}, end_id #{end_id}, weight #{weight}"
  end

  private

  def dimension
    @dimension ||= @points_enumerator.dimension
  end
end
