# frozen_string_literal: true

# Декоратор для Road
class RoadDecorator < Draper::Decorator
  delegate_all

  DEFAULT_TYPE_VALUE = 'undefined'

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
end
