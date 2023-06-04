# frozen_string_literal: true

require 'rule_list/base_rule'

module Client
  module Users
    module ValidateRules
      # Проверяем, что переданная роль является system_admin и что это не текущий пользователь
      class CouldNotDeleteSelfSystemAdmin < BaseRule
        def self.valid?(role_arguments)
          return true unless role_arguments[:role_name] == 'system_admin'

          role_arguments[:user_id] != role_arguments[:current_user_id]
        end
      end
    end
  end
end
