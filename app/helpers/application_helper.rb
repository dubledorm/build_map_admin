module ApplicationHelper

  def accessible_roles(admin_user)
    Client::Users::Services::AccessibleRoles.roles(admin_user).map do |name|
      [I18n.t("role.name.#{name || DEFAULT_NAME_VALUE}"), name]
    end
  end

  def external_svg(svg_string)
    raw svg_string
  end

  def smart_map(resource, current_point = nil)
    return resource.original_map_normalize unless resource.immutable_map.attached?

    map = resource.immutable_map.download
    roads_layer = Svg::MakeRoadsLayerService.new(resource.points, resource.roads, current_point).make

    Svg::AddRoadsLayerService.add(map, roads_layer)
  end
end
