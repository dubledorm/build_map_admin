# frozen_string_literal: true

class Api
  class V1
    # Точка входа для возврата списка групп
    class GroupsApi < Api::V1::BaseApi
      resource :groups do
        desc 'Возвращает список групп для данного здания/локации' do
          summary 'Список групп'
          detail 'Возвращает список групп'
          success Api::V1::Entities::Group
          failure [[404, 'Не найдено здание/локация с переданным building_id']]
          default [500, 'Внутрення ошибка сервера', 'Api::V1::Entities::Error']
        end
        get '/' do
          present @building.groups, with: Api::V1::Entities::Group
        end
      end
    end
  end
end
