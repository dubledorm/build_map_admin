# frozen_string_literal: true

# Класс для поиска маршрутов от точки к точке
class PathFinder
  def initialize(roads)
    @points_enumerator = PointsEnumerator.new(roads)
    @weight_matrix = WeightMatrix.new(roads, @points_enumerator)
  end

  def find(start_point_id, end_point_id)
    start_index = @points_enumerator.index_by_id(start_point_id)
    end_index = @points_enumerator.index_by_id(end_point_id)
    init_find
    calculate_all_paths(start_index)

    # path_storage.Pathes[end_index];
  end

  private

  def dimension
    @weight_matrix.dimension
  end

  def init_find
    @marks = Enumerator.produce { false }.take(dimension) # Здесь помечаем пройденные вершины
    @result_weights = [] # Сюда записываются минимальные веса от стартовой вершины до всех остальных

    # Инициализируем массив результатов (копируем сюда стартовые веса)
    (0..dimension - 1).each do |index|
      @result_weights[index] = @weights_matrix[start_index][index]

      # Инициализируем массив маршрутов (копируем сюда первый переход из стартовой точки в существующего соседа)
      next unless @result_weights[index] != UNAVAILABLE && @result_weights[index] != 0
      # path_storage.add(start_index, index, @result_weights[index], index)
    end
  end

  def calculate_all_paths(start_index)
    # Помечаем стартовую точку как пройденную
    @marks[start_index] = true

    while @marks.any?(false)
      min_result_point_number = find_min_path_to_unmarked_point
      # Помечаем найденную вершину как посещённую
      @marks[min_result_point_number] = true

      # Проверяем, что от неё нет более короткого пути к найденным
      (0..dimension - 1).each do |number_in_result|
        new_weight = path_weight(min_result_point_number, number_in_result)
        next unless @result_weights[number_in_result] > weight

        @result_weights[number_in_result] = new_weight
        # path_storage.replace(number_in_result, path_storage.Pathes[min_result_point_number])
        # path_storage.add(min_result_point_number, number_in_result, weights_matrix[min_result_point_number, number_in_result], number_in_result)
      end
    end
  end

  # Найти минимальный посчитанный маршрут среди не помеченных точек
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

  # Возвращает вес маршрута из точки current_index в точку number_in_result с учётом уже посчитанного маршрута в точку
  # number_in_result
  def path_weight(current_index, number_in_result)
    @result_weights[current_index] + @weights_matrix[number_in_result][current_index]
  end
end
