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

    marks = Enumerator.produce { false }.take(dimension) # Здесь помечаем пройденные вершины
    result_weights = [] # Сюда записываются минимальные веса от стартовой вершины до всех остальных

    # Помечаем стартовую точку как пройденную
    marks[start_index] = true

    # Инициализируем массив результатов (копируем сюда стартовые веса)
    (0..dimension - 1).each do |index|
      result_weights[index] = weights_matrix[start_index][index]
    end

    # Инициализируем массив маршрутов (копируем сюда первый переход из стартовой точки в существующего соседа)
    (0..dimension - 1).each do |index|
      next unless result_weights[index] != UNAVAILABLE && result_weights[index] != 0

      # path_storage.add(start_index, index, result_weights[index], index)
    end

    while marks.any?(false)

    end
  end

  private

    def dimension
      @weight_matrix.dimension
    end
end
