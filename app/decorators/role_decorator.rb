# frozen_string_literal: true

# Декоратор для Role
class RoleDecorator < Draper::Decorator
  delegate_all

  DEFAULT_NAME_VALUE = 'undefined'

  def name
    I18n.t("role.name.#{object.name || DEFAULT_NAME_VALUE}")
  end
end
