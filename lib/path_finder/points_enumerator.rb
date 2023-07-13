# frozen_string_literal: true

# Класс, собирающий массив из начальных и конечных точек дуг, нумерующий их
# и предоставляющий доступ к ним по индексу.
class PointsEnumerator < Enumerator
  attr_reader :point_ids

  def initialize(*several_variants, roads)
    @point_ids = roads.map(&:point1_id) | roads.map(&:point2_id)
    super(*several_variants) do |y|
      @point_ids.each do |point|
        y << point
      end
    end
  end

  def [](index)
    @point_ids[index]
  end

  def index_by_id(point_id)
    @point_ids.find_index(point_id)
  end
end
