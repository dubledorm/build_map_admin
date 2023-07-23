# frozen_string_literal: true

class Api
  class V1
    module Entities
      # Класс, описывающий ответ функции поиска
      class SearchResult < Grape::Entity
        root 'search_result'
        expose :id, documentation: { type: Integer, desc: 'Id точки', required: true }
        expose :name, documentation: { type: String, desc: 'Название точки' }
        expose :description, documentation: { type: String, desc: 'Описание' }
        expose :point_type, documentation: { values: %w[crossroads target],
                                             desc: 'Тип точки: перекрёсток/цель', required: true }
        expose :building_part_id, documentation: { type: Integer, desc: 'Часть здания к которой принадлежит точка',
                                                   required: true }
        expose :x_value, documentation: { type: Integer, desc: 'Координата x точки', required: true }
        expose :y_value, documentation: { type: Integer, desc: 'Координата y точки', required: true }
        expose :legend, documentation: { type: Integer, desc: 'Описание движения из этой точки в следующую' }
        expose :direction, documentation: { values: %w[left right up down], desc: 'Направление' }
        expose :weight, documentation: { type: Integer, desc: 'Длина перемещения в следующую точку' }
      end
    end
  end
end
