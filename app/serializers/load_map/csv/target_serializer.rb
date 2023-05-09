# frozen_string_literal: true

# Модуль группирует всё необходимое для загрузки карт и маршрутов помещений
module LoadMap
  module Csv
    # Сериализатор для Target
    class TargetSerializer
      include ActiveModel::Serialization

      attr_reader :id, :point_type, :name, :description, :x, :y

      CSV_FIELDS_ORDER = %w[id point_type x y name description].freeze

      def initialize(target)
        @id = target.id
        @point_type = target.point_type
        @name = target.name || ''
        @description = target.description || ''
        @x = target.point.x1
        @y = target.point.y1
      end

      def attributes
        { 'id' => id,
          'point_type' => point_type,
          'x' => x,
          'y' => y,
          'name' => name,
          'description' => description }
      end

      def as_csv
        CSV_FIELDS_ORDER.inject([]) { |result, field_name| result << attributes[field_name].to_s }
      end
    end
  end
end

