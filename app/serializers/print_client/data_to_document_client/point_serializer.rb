# frozen_string_literal: true

module PrintClient
  module DataToDocumentClient
    # Сериализатор для Point
    class PointSerializer
      include ActiveModel::Serialization

      attr_reader :building_name, :target_name, :qr_code

      def initialize(point)
        @building_name = point.building.name
        @target_name = point.name
        @qr_code = '12345'
      end

      def attributes
        { 'building_name' => building_name,
          'target_name' => target_name,
          'qr_code' => qr_code }
      end
    end
  end
end

