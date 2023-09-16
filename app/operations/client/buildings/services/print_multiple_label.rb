# frozen_string_literal: true

module Client
  module Buildings
    module Services
      # Отпечатать много этикеток
      class PrintMultipleLabel
        #   ROADS_LAYER_NAME = Settings.svg_file.roads_layer_name

        def initialize
          if Settings.print_client_class.blank?
            raise I18n.t('operations.client.buildings.services.print_single_label.undefined_client')
          end

          @print_client = Settings.print_client_class.constantize.new
        end

        def call(points, template_name)
          Client::Buildings::Dto::PrintMultipleLabelResponse.success(@print_client.multiple_print!(points, template_name))
        rescue StandardError => e
          Client::Buildings::Dto::PrintMultipleLabelResponse.error(e.message)
        end

        private

      end
    end
  end
end
