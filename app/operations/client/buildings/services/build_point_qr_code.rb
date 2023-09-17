# frozen_string_literal: true

module Client
  module Buildings
    module Services
      # Отпечатать одну этикетку
      class BuildPointQrCode
        def self.call(point)
          if Settings.qr_code.user_site_base_url.blank?
            raise I18n.t('operations.client.buildings.services.print_single_label.undefined_user_site_base_url')
          end

          make_url(Settings.qr_code.user_site_base_url, "search?#{ { building_id: point.building.id,
                                                                     target_id: point.id }.to_query }")
        end

        def self.make_url(*args)
          parts = args.map { |part| part.end_with?('/') ? part[0..-2] : part }
          parts.join('/')
        end
      end
    end
  end
end
