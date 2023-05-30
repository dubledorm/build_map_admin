# frozen_string_literal: true

module Client
  module Services
    # Процесс регистрации нового клиента
    class Registration
      def self.call(organization_name, email, password, password_confirmation)
        admin_user = nil
        ActiveRecord::Base.transaction do
          organization_id = Organization.create!(name: organization_name).id
          admin_user = AdminUser.create(email:, password:, password_confirmation:, organization_id:)
          return { error_code: -2, admin_user: } unless admin_user.persisted?

          Role.create!(name: 'client_owner', admin_user_id: admin_user.id)
        end

        { error_code: 0, admin_user_id: admin_user.id }
      rescue StandardError => e
        { error_code: -1, message: e.message }
      end
    end
  end
end
