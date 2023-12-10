# frozen_string_literal: true

class Api
  class V1
    # Точка входа для предоставления информации о точках
    class PointsApi < Api::V1::BaseApi
      resource :points do
        desc 'Найти точку по Id' do
          success Api::V1::Entities::Point
          failure [[404, 'Не найдено здание/локация с переданным building_id', 'Api::V1::Entities::Error']]
          default [500, 'Внутрення ошибка сервера', Api::V1::Entities::Error]
        end

        params do
          requires :point_id, type: Integer, desc: 'Id точки'
        end
        route_param :point_id do
          get do
            point = @building.points.where(id: params[:point_id]).targets
            present point, with: Api::V1::Entities::Point
          end
        end
      end
    end
  end
end
