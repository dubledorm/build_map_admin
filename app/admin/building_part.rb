ActiveAdmin.register BuildingPart do
  permit_params :building_id, :name, :description, :state, :original_map
  actions :index, :show, :edit, :update, :destroy
  filter :building
  filter :name
  filter :state, as: :check_boxes,
                 collection: proc { BuildingPartDecorator.states }
  filter :created_at
  filter :updated_at

  decorate_with BuildingPartDecorator

  index do
    selectable_column
    id_column
    column :building
    column :name
    column :state
    column :description
    column :created_at
    column :updated_at
    actions
  end

  form do |f|
    f.semantic_errors *f.object.errors
    f.inputs do
      f.input :name
      f.input :description, as: :text
      f.input :state, as: :select, collection: BuildingPartDecorator.states
      panel I18n.t('my_active_admin.building_part.original_map') do
        f.file_field :original_map
      end
    end

    f.actions
  end

  show do
    panel BuildingPart.model_name.human do
      attributes_table_for building_part do
        row :building
        row :organization
        row :name
        row :state
        row :description
        row :created_at
        row :updated_at
      end
    end

    panel I18n.t('my_active_admin.building_part.original_map') do
      external_svg(resource.original_map_normalize) if resource.original_map.attached?
    end
  end

  action_item :update_routes, only: :show do
    if can?(:update_routes, BuildingPart)
      link_to I18n.t('my_active_admin.building_part.update_routes'),
              update_routes_admin_building_part_path(id: resource.id), method: :put
    end
  end

  member_action :update_routes, method: :put do

    redirect_to admin_building_part_path(id: resource.id), notice: I18n.t('my_active_admin.building_part.routes_updated_notice')
  end
end
