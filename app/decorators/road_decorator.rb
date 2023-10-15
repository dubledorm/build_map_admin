# frozen_string_literal: true

# Декоратор для Road
class RoadDecorator < Draper::Decorator
  delegate_all

  DEFAULT_TYPE_VALUE = 'road'
  DEFAULT_EXIT_DIRECTION_VALUE = 'undefined'

  def road_type
    I18n.t("road.road_type.#{object.road_type || DEFAULT_TYPE_VALUE}")
  end

  def name
    "#{object.point1.name} -> #{object.point2.name} "
  end

  def self.road_types
    Road::ROAD_TYPE_VALUES.map { |type_value| [I18n.t("road.road_type.#{type_value}"), type_value] }
  end

  def self.points(building)
    building.points.where('points.name <> ?', '').map { |point| [point.name, point.id] }
  end

  def self.exit_map_directions
    Road::EXIT_MAP_DIRECTION_VALUES.map { |exit_map_direction| [I18n.t("road.exit_map_direction.#{exit_map_direction}"), exit_map_direction] }
  end

  def exit_map_direction1
    I18n.t("road.exit_map_direction.#{object.exit_map_direction1 || DEFAULT_EXIT_DIRECTION_VALUE}")
  end

  def exit_map_direction2
    I18n.t("road.exit_map_direction.#{object.exit_map_direction2 || DEFAULT_EXIT_DIRECTION_VALUE}")
  end
end
