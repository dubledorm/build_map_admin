# frozen_string_literal: true

class Api
  class V1
    module Entities
      # Класс, описывающий ответ функции поиска
      class SearchResult < Grape::Entity
        root 'search_result'
        expose :id, documentation: { type: Integer, desc: 'Id дуги', required: true }
      end
    end
  end
end
