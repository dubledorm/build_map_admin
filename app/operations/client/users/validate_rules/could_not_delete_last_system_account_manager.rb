# frozen_string_literal: true

require 'rule_list/base_rule'

module Client
  module Users
    module ValidateRules
      # Проверяем, что переданная роль является system_account_manager и что она не последняя для данной организации
      class CouldNotDeleteLastSystemAccountManager < BaseRule
        def self.valid?(role_arguments)
          return true unless role_arguments[:role_name] == 'system_account_manager'

          Organization.joins(admin_users: [:roles]).where(id: role_arguments[:organization_id],
                                                          roles: { name: 'system_account_manager' }).count > 1
        end
      end
    end
  end
end
