# frozen_string_literal: true

module Client
  module Buildings
    module Services
      # Обновить таблицы маршрутов и точек в building_part, на основании плана помещения и переданного xls файла
      class UpdateRoutes

        def initialize(building_part, building_part_update_routes)
          @content_of_xls_file = building_part_update_routes.routes_xls.tempfile.read
          @content_of_svg_file = building_part.original_map.download
          @building_part = building_part
          @saver = LoadMap::Db::Saver.new(building_part.id)
        end

        def call
          ActiveRecord::Base.transaction do
            clear
            LoadMap::LoadRoads.new(@content_of_svg_file, @content_of_xls_file, @saver).done
          end

          Client::Buildings::Dto::UpdateRoutesResponse.success(@building_part)
        rescue StandardError => e
          Client::Buildings::Dto::UpdateRoutesResponse.error(e.message)
        end

        private

        def clear
          @building_part.roads.destroy_all
          @building_part.points.destroy_all
        end
      end
    end
  end
end
