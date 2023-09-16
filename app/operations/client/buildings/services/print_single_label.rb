# frozen_string_literal: true

module Client
  module Buildings
    module Services
      # Отпечатать одну этикетку
      class PrintSingleLabel

        def initialize
          if Settings.print_client_class.blank?
            raise I18n.t('operations.client.buildings.services.print_single_label.undefined_client')
          end

          @print_client = Settings.print_client_class.constantize.new
        end

        def call(point, template_name)
          Client::Buildings::Dto::PrintSingleLabelResponse.success(@print_client.single_print!(point, template_name))
        rescue StandardError => e
          Client::Buildings::Dto::PrintSingleLabelResponse.error(e.message)
        end
      end
    end
  end
end
