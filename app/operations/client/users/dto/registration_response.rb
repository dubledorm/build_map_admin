# frozen_string_literal: true

module Client
  module Users
    module Dto
      # Класс, определяющий ответ функций сервиса Registration
      class RegistrationResponse < BaseResponse
        def user
          @result
        end

        def self.validate!(user)
          return if user.is_a?(AdminUser)

          raise 'User should be AdminUser'
        end
      end
    end
  end
end
