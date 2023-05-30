# frozen_string_literal: true

# Декоратор для Role
class RoleDecorator < Draper::Decorator
  delegate_all

  DEFAULT_NAME_VALUE = 'undefined'

  def name
    I18n.t("role.name.#{object.name || DEFAULT_NAME_VALUE}")
  end

  def self.translate_role_names
    Role::ROLE_NAMES.map { |name| [I18n.t("role.name.#{name || DEFAULT_NAME_VALUE}"), name] }
  end
end
