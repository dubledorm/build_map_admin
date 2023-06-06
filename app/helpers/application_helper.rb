module ApplicationHelper

  def accessible_roles(admin_user)
    Client::Users::Services::AccessibleRoles.roles(admin_user).map do |name|
      [I18n.t("role.name.#{name || DEFAULT_NAME_VALUE}"), name]
    end
  end

  def external_svg(svg_string)
    raw svg_string
  end
end
