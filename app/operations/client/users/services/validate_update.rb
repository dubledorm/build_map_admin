# frozen_string_literal: true

require 'rule_list/rule_list'
require 'rule_list/rule_list_item'

module Client
  module Users
    module Services
      # Проверяет что можно выполнить операцию Update
      # После выполнения функции valid? заполняет массив errors струкутурами hash вида:
      # { role: role_arguments, messages: }
      # где role_arguments это тоже hash:
      #  { role_name: item[1]['name'],
      #   role_id: item[1]['id'],
      #   organization_id: @admin_user.organization_id,
      #   user_id: @admin_user.id,
      #   current_user_id: @current_user.id }
      class ValidateUpdate
        attr_reader :errors

        DESTROY_TRUE_FLAG = '1'
        DELETE_ROLES_CHECK_LIST = RuleList.new(
          [RuleListItem.new(Client::Users::ValidateRules::CouldNotDeleteLastClientOwner,
                            I18n.t('operations.client.users.services.validate_update.CouldNotDeleteLastClientOwner')),
           RuleListItem.new(Client::Users::ValidateRules::CouldNotDeleteSelfClientOwner,
                            I18n.t('operations.client.users.services.validate_update.CouldNotDeleteSelfClientOwner')),
           RuleListItem.new(Client::Users::ValidateRules::CouldNotDeleteLastSystemAdmin,
                            I18n.t('operations.client.users.services.validate_update.CouldNotDeleteLastSystemAdmin')),
           RuleListItem.new(Client::Users::ValidateRules::CouldNotDeleteSelfSystemAdmin,
                            I18n.t('operations.client.users.services.validate_update.CouldNotDeleteSelfSystemAdmin')),
           RuleListItem.new(Client::Users::ValidateRules::CouldNotDeleteLastSystemAccountManager,
                            I18n.t('operations.client.users.services.validate_update.CouldNotDeleteLastSystemAccountManager')),
           RuleListItem.new(Client::Users::ValidateRules::CouldNotDeleteSelfSystemAccountManager,
                            I18n.t('operations.client.users.services.validate_update.CouldNotDeleteSelfSystemAccountManager'))]
        ).freeze

        def initialize(params_admin_user, admin_user, current_user)
          @admin_user = admin_user
          @current_user = current_user
          @errors = []
          parse_params(params_admin_user)
        end

        def valid?
          @errors = check_deleted_roles
          @errors.empty?
        end

        private

        def parse_params(params_admin_user)
          @deleted_roles = params_admin_user['roles_attributes']&.to_enum&.each_with_object([]) do |item, result|
            next unless item[1]['_destroy'] == DESTROY_TRUE_FLAG

            result << role_to_hash(item)
          end || []
        end

        def check_deleted_roles
          @deleted_roles.each_with_object([]) do |role_arguments, result|
            next if DELETE_ROLES_CHECK_LIST.valid?(role_arguments)

            result << { role: role_arguments, messages: DELETE_ROLES_CHECK_LIST.errors }
          end
        end

        def role_to_hash(item)
          { role_name: item[1]['name'],
            role_id: item[1]['id'],
            organization_id: @admin_user.organization_id,
            user_id: @admin_user.id,
            current_user_id: @current_user.id }
        end
      end
    end
  end
end
