# frozen_string_literal: true

class Api
  class V1
    # Точка входа для поиска возможных целей
    class TargetsApi < Api::V1::BaseApi
      resource :targets do
        params do
          optional :filter, type: Hash do
            optional :group_id, type: Integer, desc: 'Id группы'
            optional :target_name, type: String, desc: 'Часть названия точки'
          end
        end

        desc 'Возвращает коллекцию targets, содержащую список точек' do
          summary 'Найти возможные точки'
          detail 'Возвращает список точек с учётом переданных парметров фильтра, таких как группа и часть имени'
          success Api::V1::Entities::Target
          failure [[404, 'Не найдено здание/локация с переданным building_id', 'Api::V1::Entities::Error']]
          default [500, 'Внутрення ошибка сервера', 'Api::V1::Entities::Error']
        end
        get '/' do
          #{ 'declared_params' => declared(params) }
          points = @building.points
          points = points.by_name(params[:filter][:target_name]) if params.dig(:filter, :target_name)
          present points, with: Api::V1::Entities::Target
        end
      end
    end
  end
end
