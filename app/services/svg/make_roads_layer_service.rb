# frozen_string_literal: true

module Svg
  # Формирует строку с Roads уровнем, на основании переданного списка точек и дуг
  class MakeRoadsLayerService

    POINT_TYPE_TO_CLASS = { crossroads: 'point_crossroads',
                            target: 'point_target',
                            current: 'point_current',
                            staircase: 'point_staircase',
                            undefined: 'point_undefined' }.freeze

    def initialize(points, roads, current_point = nil)
      @points = points
      @roads = roads
      @current_point = current_point
      @points_hash = {}
      @staircase_point_ids = []
      building = points.first&.building
      @staircase_point_ids = building.roads.staircase_only.pluck(:point1_id, :point2_id).flatten.uniq if building
    end

    def make
      "<g class=\"layer\">\n  <title>Roads</title>  #{points}\n  #{roads}\n</g>"
    end

    private

    def points
      @points.inject('') do |result, point|
        decorate_point = point.decorate
        @points_hash[point.id] = { x: decorate_point.x_value, y: decorate_point.y_value }
        result + "<circle cx=\"#{decorate_point.x_value}\" cy=\"#{decorate_point.y_value}\" id=\"#{point.id}\"
 r=\"7\" class=\"point_click #{point_class(point)}\"/>\n"
      end
    end

    def roads
      @roads.includes(:point1, :point2).road_only.inject('') do |result, road|
        result + "<line class=\"road_svg\"
 x1=\"#{@points_hash.dig(road.point1.id, :x)}\"
 x2=\"#{@points_hash.dig(road.point2.id, :x)}\"
 y1=\"#{@points_hash.dig(road.point1.id, :y)}\"
 y2=\"#{@points_hash.dig(road.point2.id, :y)}\"/>\n"
      end
    end

    def point_class(point)
      result = []
      result << POINT_TYPE_TO_CLASS[:current] if @current_point && point.id == @current_point.id

      result << POINT_TYPE_TO_CLASS[point.point_type.to_sym] || POINT_TYPE_TO_CLASS[:undefined]
      result << POINT_TYPE_TO_CLASS[:staircase] if @staircase_point_ids.include?(point.id)
      result.join(' ')
    end
  end
end
