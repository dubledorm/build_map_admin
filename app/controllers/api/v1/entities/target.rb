# frozen_string_literal: true

class Api
  class V1
    module Entities
      # Класс, описывающий один элемент возвращаемый функцией targets_api
      class Target < Grape::Entity
        root 'targets'
        expose :id, documentation: { type: Integer, desc: 'Id точки', required: true }
        expose :name, documentation: { type: String, desc: 'Название точки', required: true }
      end
    end
  end
end
