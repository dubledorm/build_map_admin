# frozen_string_literal: true

class Api
  class V1
    module Entities
      # Класс, описывающий сообщение об ошибке
      class Error < Grape::Entity
        expose :code, documentation: { type: Integer, desc: 'Код ошибки' }
        expose :message, documentation: { type: String, desc: 'Сообщение об ошибке' }
      end
    end
  end
end
