# frozen_string_literal: true

require 'path_finder/weights_matrix'
require 'path_finder/path_storage'

# Класс для поиска маршрутов от точки к точке
class PathFinder
  attr_reader :roads_adapter, :path_storage

  delegate :find_point_index, to: :roads_adapter

  def initialize(roads_adapter)
    @roads_adapter = roads_adapter
    @weights_matrix = WeightsMatrix.new(@roads_adapter)
    @path_storage = PathStorage.new(@roads_adapter)
  end

  def find(start_point_id, end_point_id)
    start_index = find_point_index(start_point_id)
    end_index = find_point_index(end_point_id)
    init_find(start_index)
    calculate_all_paths(start_index)

    @path_storage.paths[end_index]
  end

  private

  def dimension
    @weights_matrix.dimension
  end

  def init_find(start_index)
    @marks = Enumerator.produce { false }.take(dimension) # Здесь помечаем пройденные вершины
    @result_weights = [] # Сюда записываются минимальные веса от стартовой вершины до всех остальных

    # Инициализируем массив результатов (копируем сюда стартовые веса)
    (0..dimension - 1).each do |index|
      @result_weights[index] = @weights_matrix.weight(start_index, index)

      # Инициализируем массив маршрутов (копируем сюда первый переход из стартовой точки в существующего соседа)
      next unless @result_weights[index] != PathFinderConst::UNAVAILABLE && @result_weights[index] != 0

      @path_storage.add(@roads_adapter.find_road_index(start_index, index, @result_weights[index]), index)
    end
  end

  def calculate_all_paths(start_index)
    # Помечаем стартовую точку как пройденную
    @marks[start_index] = true

    while @marks.any?(false)
      # Найти маршрут минимального веса
      min_result_point_number = find_min_path_to_unmarked_point
      # Помечаем найденную вершину как посещённую
      @marks[min_result_point_number] = true

      # Проверяем, что от неё нет более короткого пути к найденным
      check_old_paths(min_result_point_number)
    end
  end

  # Найти в @result_weights маршрут минимального веса ведущий в не пройденную точку
  def find_min_path_to_unmarked_point
    min_result_point_number = -1
    (0..dimension - 1).each do |number_in_result|
      next if @marks[number_in_result] # Пропускаем если точка уже помечена пройденной

      if min_result_point_number == -1 ||
         @result_weights [min_result_point_number] > @result_weights [number_in_result]
        min_result_point_number = number_in_result
      end
    end
    min_result_point_number
  end

  # Проверяем, что от точки нет более короткого пути к уже найденным
  def check_old_paths(point_number)
    (0..dimension - 1).each do |number_in_result|
      new_weight = path_weight(point_number, number_in_result)
      next unless @result_weights[number_in_result] > new_weight

      @result_weights[number_in_result] = new_weight
      place_on_path_storage(number_in_result, point_number)
    end
  end

  # Возвращает вес маршрута из точки current_index в точку number_in_result с учётом уже посчитанного маршрута в точку
  # number_in_result
  def path_weight(current_index, number_in_result)
    @result_weights[current_index] + @weights_matrix.weight(current_index, number_in_result)
  end

  def place_on_path_storage(number_in_result, min_result_point_number)
    @path_storage.replace(number_in_result, @path_storage.paths[min_result_point_number])
    road_index = @roads_adapter.find_road_index(min_result_point_number, number_in_result,
                                                @weights_matrix.weight(min_result_point_number, number_in_result))
    @path_storage.add(road_index, number_in_result)
  end
end
