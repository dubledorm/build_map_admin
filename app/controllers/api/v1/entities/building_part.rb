# frozen_string_literal: true

class Api
  class V1
    module Entities
      # Класс, описывающий ответ функции поиска
      class BuildingPart < Grape::Entity
        expose :name, documentation: { type: String, desc: 'Название' }
        expose :map_scale, documentation: { type: String, desc: 'Маштаб карты' }
        expose :immutable_map_url, documentation: { type: String, desc: 'Карта' }

        private

        def immutable_map_url
          Rails.application.routes.url_helpers.rails_blob_path(object.immutable_map, only_path: true)
        end
      end
    end
  end
end
