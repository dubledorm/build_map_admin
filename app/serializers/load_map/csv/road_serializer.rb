# frozen_string_literal: true

# Модуль группирует всё необходимое для загрузки карт и маршрутов помещений
module LoadMap
  module Csv
    # Сериализатор для Road
    class RoadSerializer
      include ActiveModel::Serialization

      attr_reader :start_id, :end_id, :weight

      CSV_FIELDS_ORDER = %w[start_id end_id weight].freeze

      def initialize(road)
        @start_id = road.start_id
        @end_id = road.end_id
        @weight = road.weight
      end

      def attributes
        { 'start_id' => start_id,
          'end_id' => end_id,
          'weight' => weight }
      end

      def as_csv
        CSV_FIELDS_ORDER.inject([]) { |result, field_name| result << attributes[field_name].to_s }
      end
    end
  end
end

