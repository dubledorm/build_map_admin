# frozen_string_literal: true

# Декоратор для Point
class PointDecorator < Draper::Decorator
  delegate_all

  DEFAULT_TYPE_VALUE = 'undefined'

  def point_type
    I18n.t("point.point_type.#{object.name || DEFAULT_NAME_VALUE}")
  end
end
