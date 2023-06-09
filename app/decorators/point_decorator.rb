# frozen_string_literal: true

# Декоратор для Point
class PointDecorator < Draper::Decorator
  delegate_all

  DEFAULT_TYPE_VALUE = 'undefined'
  NORMALIZE_RANGE = Settings.svg_file.normalize_coordinate_limit # До скольки знаков обрезать дробную часть координат

  def point_type
    I18n.t("point.point_type.#{object.point_type || DEFAULT_TYPE_VALUE}")
  end

  def self.point_types
    Point::POINT_TYPE_VALUES.map { |type_value| [I18n.t("point.point_type.#{type_value}"), type_value] }
  end

  def x_value
    s_value = object.x_value.to_s
    "#{s_value[0..-NORMALIZE_RANGE - 1]}.#{s_value[-NORMALIZE_RANGE..]}"
  end

  def y_value
    s_value = object.y_value.to_s
    "#{s_value[0..-NORMALIZE_RANGE - 1]}.#{s_value[-NORMALIZE_RANGE..]}"
  end
end
