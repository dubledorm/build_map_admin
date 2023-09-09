# frozen_string_literal: true

module Client
  module Buildings
    module Services
      # Отпечатать одну этикетку
      class PrintSingleLabel
        #   ROADS_LAYER_NAME = Settings.svg_file.roads_layer_name

        def initialize(point)
          @point = point
        end

        def call
          # TODO Здесь вызов апи для печати этикетки

          Client::Buildings::Dto::PrintSingleLabelResponse.success('')
        rescue StandardError => e
          Client::Buildings::Dto::PrintSingleLabelResponse.error(e.message)
        end

        private

      end
    end
  end
end
