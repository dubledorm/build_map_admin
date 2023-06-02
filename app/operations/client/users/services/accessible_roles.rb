# frozen_string_literal: true

module Client
  module Users
    module Services
      # Возвращает список ролей, которые может назначать текущий пользователь (в зависимости от его роли)
      class AccessibleRoles
        ROLES_MAP = { client_owner: %i[client_owner client_user],
                      system_account_manager: %i[system_manager system_admin] }.freeze

        def self.roles(admin_user)
          return [] unless admin_user

          admin_user.roles.inject([]) do |result, role|
            result + (ROLES_MAP[role.name.to_sym] || [])
          end.uniq
        end
      end
    end
  end
end
