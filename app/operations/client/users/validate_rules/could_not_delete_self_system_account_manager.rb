# frozen_string_literal: true

require 'rule_list/base_rule'

module Client
  module Users
    module ValidateRules
      # Проверяем, что переданная роль является system_account_manager и что это не текущий пользователь
      class CouldNotDeleteSelfSystemAccountManager < BaseRule
        def self.valid?(role_arguments)
          return true unless role_arguments[:role_name] == 'system_account_manager'

          role_arguments[:user_id] != role_arguments[:current_user_id]
        end
      end
    end
  end
end
