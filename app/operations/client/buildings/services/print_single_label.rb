# frozen_string_literal: true

module Client
  module Buildings
    module Services
      # Отпечатать одну этикетку
      class PrintSingleLabel
        #   ROADS_LAYER_NAME = Settings.svg_file.roads_layer_name

        def initialize(point, template_name)
          @point = point
          @print_client = PrintClient::DataToDocument.new(template_name)
        end

        def call
          Client::Buildings::Dto::PrintSingleLabelResponse.success(@print_client.single_print!(@point))
        rescue StandardError => e
          Client::Buildings::Dto::PrintSingleLabelResponse.error(e.message)
        end
      end
    end
  end
end
