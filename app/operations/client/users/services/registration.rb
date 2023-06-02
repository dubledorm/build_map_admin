# frozen_string_literal: true

module Client
  module Users
    module Services
      # Процесс регистрации нового клиента
      class Registration
        BAD_ADMIN_MESSAGE = 'operations.client.users.services.registration.bad_admin_user'
        def self.client_owner(organization_name, email, password, password_confirmation)
          admin_user = nil
          ActiveRecord::Base.transaction do
            organization_id = Organization.create!(name: organization_name).id
            admin_user = AdminUser.create(email:, password:, password_confirmation:, organization_id:)
            raise StandardError, I18n.t(BAD_ADMIN_MESSAGE) unless admin_user.persisted?

            Role.create!(name: 'client_owner', admin_user_id: admin_user.id)
          end

          Client::Users::Dto::RegistrationResponse.success(admin_user)
        rescue StandardError => e
          Client::Users::Dto::RegistrationResponse.error_with_object(e.message, admin_user)
        end
      end
    end
  end
end
