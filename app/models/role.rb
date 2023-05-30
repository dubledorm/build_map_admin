# frozen_string_literal: true

# Запись для сохранения ролей пользователей
class Role < ApplicationRecord
  ROLE_NAMES = %w[client_owner client_user system_manager system_admin system_account_manager].freeze

  belongs_to :admin_user

  validates :name, presence: true, inclusion: { in: ROLE_NAMES }

  def organization_id
    admin_user.organization_id
  end
end
