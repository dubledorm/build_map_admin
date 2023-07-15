# frozen_string_literal: true

require 'path_finder/path_finder_const'

# Класс, формирующий матрицу весов из переданных маршрутов
# и обеспечивающий доступ к весам по индексу - столбцу и колонке
class WeightMatrix
  include PathFinderConst

  attr_reader :weights_matrix, :dimension

  def initialize(roads_adapter)
    @dimension = roads_adapter.point_entities.count
    @weights_matrix = []
    fill_weight_matrix(roads_adapter) if @dimension.positive?
  end

  def weight(row_index, column_index)
    @weights_matrix[row_index][column_index]
  end

  private

  def fill_weight_matrix(roads_adapter)
    init_matrix
    fill_weights(roads_adapter)
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

  def fill_weights(roads_adapter)
    # Проставляем реальные веса
    roads_adapter.road_entities.each do |road_entity|
      weights_matrix[road_entity.point1_index][road_entity.point2_index] = road_entity.weight
      weights_matrix[road_entity.point2_index][road_entity.point1_index] = road_entity.weight
    end
  end
end
