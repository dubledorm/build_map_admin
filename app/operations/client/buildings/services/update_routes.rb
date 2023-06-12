# frozen_string_literal: true

module Client
  module Buildings
    module Services
      # Обновить таблицы маршрутов и точек в building_part, на основании плана помещения и переданного xls файла
      # Отделить в original_map план помещения от уровня маршрутов и записать его в immutable_map
      class UpdateRoutes
        # TODO: Вынести в настройки(и в svg_parser тоже)
        ROADS_LAYER_NAME = 'Roads'

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
            immutable_map = Svg::DropLayerService.drop(Svg::NormalizeService.call(@content_of_svg_file),
                                                       ROADS_LAYER_NAME)
            add_immutable_map(immutable_map)
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

        def add_immutable_map(immutable_map_buffer)
          @building_part.immutable_map.attach(io: StringIO.new(immutable_map_buffer),
                                              filename: "immutable_map_#{@building_part.id}.svg",
                                              content_type: 'image/svg')
          @building_part.save
        end
      end
    end
  end
end
