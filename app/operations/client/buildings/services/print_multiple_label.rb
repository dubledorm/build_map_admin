# frozen_string_literal: true

module Client
  module Buildings
    module Services
      # Отпечатать много этикеток
      class PrintMultipleLabel
        #   ROADS_LAYER_NAME = Settings.svg_file.roads_layer_name

        def initialize(points, template_name)
          @points = points
          @print_client = PrintClient::DataToDocument.new(template_name)
        end

        def call
          Client::Buildings::Dto::PrintMultipleLabelResponse.success(@print_client.multiple_print!(@points))
        rescue StandardError => e
          Client::Buildings::Dto::PrintMultipleLabelResponse.error(e.message)
        end

        private

      end
    end
  end
end
