# frozen_string_literal: true

class Api
  class V1
    module Entities
      # Класс, описывающий один элемент возвращаемый функцией targets_api
      class Group < Grape::Entity
        root 'groups'
        expose :id, documentation: { type: Integer, desc: 'Id группы', required: true }
        expose :name, documentation: { type: String, desc: 'Название группы', required: true }
        expose :description, documentation: { type: String, desc: 'Описание группы', required: true }
      end
    end
  end
end
