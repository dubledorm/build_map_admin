# frozen_string_literal: true

class Api
  class V1
    # Точка входа для предоставления информации о части здания
    class BuildingPartsApi < Api::V1::BaseApi
      resource :building_parts do
        desc 'Найти часть здания по Id' do
          success Api::V1::Entities::BuildingPart
          failure [[404, 'Не найдено здание/локация с переданным building_id', 'Api::V1::Entities::Error']]
          default [500, 'Внутрення ошибка сервера', Api::V1::Entities::Error]
        end
        params do
          requires :building_part_id, type: Integer, desc: 'Id части здания'
        end
        route_param :building_part_id do
          get do
            building_part = @building.building_parts.where(id: params[:building_part_id])
            present building_part, with: Api::V1::Entities::BuildingPart
          end
        end


        desc 'Вернуть все части здания' do
          success Api::V1::Entities::BuildingPart
          default [500, 'Внутрення ошибка сервера', Api::V1::Entities::Error]
        end
        get do
          present @building.building_parts, with: Api::V1::Entities::BuildingPart
        end
      end
    end
  end
end
