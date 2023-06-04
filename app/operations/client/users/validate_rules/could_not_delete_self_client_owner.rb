# frozen_string_literal: true

require 'rule_list/base_rule'

module Client
  module Users
    module ValidateRules
      # Проверяем, что переданная роль является client_owner и что это не текущий пользователь
      class CouldNotDeleteSelfClientOwner < BaseRule
        def self.valid?(role_arguments)
          return true unless role_arguments[:role_name] == 'client_owner'

          role_arguments[:user_id] != role_arguments[:current_user_id]
        end
      end
    end
  end
end
