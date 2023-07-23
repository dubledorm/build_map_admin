# frozen_string_literal: true

class Api
  class V1
    module Entities
      # Класс, описывающий ответ функции поиска
      class Point < Grape::Entity
        expose :name, documentation: { type: String, desc: 'Название точки' }
        expose :description, documentation: { type: String, desc: 'Описание' }
        expose :point_type, documentation: { values: %w[crossroads target],
                                             desc: 'Тип точки: перекрёсток/цель', required: true }
        expose :building_part_id, documentation: { type: Integer, desc: 'Часть здания к которой принадлежит точка',
                                                   required: true }
        expose :x_value, documentation: { type: Integer, desc: 'Координата x точки', required: true }
        expose :y_value, documentation: { type: Integer, desc: 'Координата y точки', required: true }
      end
    end
  end
end
