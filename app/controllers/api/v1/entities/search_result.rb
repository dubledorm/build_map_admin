# frozen_string_literal: true

class Api
  class V1
    module Entities
      # Класс, описывающий ответ функции поиска
      class SearchResult < Grape::Entity
        root 'search_result'
        expose :point_id, documentation: { type: Integer, desc: 'Id точки', required: true }
        expose :point, using: Api::V1::Entities::Point, as: :point
        expose :legend, documentation: { type: Integer, desc: 'Описание движения из этой точки в следующую' }
        expose :direction, documentation: { values: %w[left right up down], desc: 'Направление' }
        expose :weight, documentation: { type: Integer, desc: 'Длина перемещения в следующую точку' }
      end
    end
  end
end
