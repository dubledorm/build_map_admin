# frozen_string_literal: true

module Core
  module Routes
    module Dto
      # Класс, определяющий ответ функций сервиса FindPath
      class FindPathResponse < BaseResponse

        def path
          @result
        end
      end
    end
  end
end
