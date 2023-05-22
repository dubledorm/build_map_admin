# frozen_string_literal: true
require 'csv'

# Модуль группирует всё необходимое для загрузки карт и маршрутов помещений
module LoadMap
  module Factories
    # Фабрика для создания Point из Target
    class PointFromTarget
      def self.build(target)
        Point.new(point_type: target.point_type,
                  name: target.name,
                  description: target.description,
                  x_value: target.point&.x1,
                  y_value: target.point&.y1)
      end
    end
  end
end

