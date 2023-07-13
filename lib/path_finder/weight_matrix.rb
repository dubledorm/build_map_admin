# frozen_string_literal: true

require 'path_finder/path_finder_const'

# Класс, формирующий матрицу весов из переданных маршрутов
# и обеспечивающий доступ к весам по индексу - столбцу и колонке
class WeightMatrix
  include PathFinderConst

  attr_reader :weights_matrix, :dimension

  def initialize(roads, points_enumerator)
    @dimension = points_enumerator.count
    @points_enumerator = points_enumerator
    @weights_matrix = []
    fill_weight_matrix(roads) if @dimension.positive?
  end

  def weight(row_index, column_index)
    @weights_matrix[row_index][column_index]
  end

  private

  def fill_weight_matrix(roads)
    init_matrix
    fill_weights(roads)
  end

  def init_matrix
    # Заполняем диагональ 0, всё остальное UNAVAILABLE
    @weights_matrix = Enumerator.produce do
      Enumerator.produce { UNAVAILABLE }.take(@dimension)
    end.take(@dimension)

    (0..@dimension - 1).each do |index|
      @weights_matrix[index][index] = 0
    end
  end

  def fill_weights(roads)
    # Проставляем реальные веса
    roads.each do |road|
      weights_matrix[to_index(road.point1_id)][to_index(road.point2_id)] = road.weight
      weights_matrix[to_index(road.point2_id)][to_index(road.point1_id)] = road.weight
    end
  end

  def to_index(point_id)
    @points_enumerator.index_by_id(point_id)
  end
end
