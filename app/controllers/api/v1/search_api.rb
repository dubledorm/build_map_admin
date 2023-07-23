# frozen_string_literal: true

class Api
  class V1
    # Точка входа для поиска маршрута между двумя точками
    class SearchApi < Api::V1::BaseApi
      resource :search do
        params do
          requires :start_point_id, type: Integer, desc: 'Id точки начала маршрута'
          requires :end_point_id, type: Integer, desc: 'Id точки конца маршрута'
        end

        desc 'Возвращает маршрут для прохода от точки start_point в точку end_point' do
          summary 'Поиск маршрута'
          detail 'Возвращает список точек'
          success Api::V1::Entities::SearchResult
          failure [[404, 'Не найдено здание/локация с переданным building_id'],
                   [400, 'Точка с id = XXX не принадлежит зданию с id = XXX']]
          default [500, 'Внутрення ошибка сервера', 'Api::V1::Entities::Error']
        end
        get '/' do
          response = Core::Routes::Services::FindPath.new(@building.id,
                                                          params[:start_point_id],
                                                          params[:end_point_id]).find

          present response.path, with: Api::V1::Entities::SearchResult if response.success?
          unless response.success?
            present Api::V1::Entities::Error.new(code: 500, message: response.message),
                    with: Api::V1::Entities::Error
          end
        end
      end
    end
  end
end
