# frozen_string_literal: true

module Client
  module Users
    module Services
      # Создать новый дополнительный Accaunt клиента
      class AddUser
        BAD_ADMIN_MESSAGE = 'operations.client.users.services.registration.bad_admin_user'
        DEFAULT_PASSWORD = 'user_password'

        def self.client_user(organization_id, email)
          admin_user = nil
          ActiveRecord::Base.transaction do
            admin_user = AdminUser.create(email:, password: DEFAULT_PASSWORD,
                                          password_confirmation: DEFAULT_PASSWORD, organization_id:)
            raise StandardError, I18n.t(BAD_ADMIN_MESSAGE) unless admin_user.persisted?

            Role.create!(name: 'client_user', admin_user_id: admin_user.id)
          end

          Client::Users::Dto::RegistrationResponse.success(admin_user)
        rescue StandardError => e
          Client::Users::Dto::RegistrationResponse.error_with_object(e.message, admin_user)
        end
      end
    end
  end
end
