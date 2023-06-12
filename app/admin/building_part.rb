ActiveAdmin.register BuildingPart do
  permit_params :building_id, :name, :description, :state, :original_map, :building_part_update_routes
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

    tabs do
      tab I18n.t('my_active_admin.building_part.original_map') do
        render 'original_map'
      end
      tab 'immutable_map' do
        render 'immutable_map'
      end
      tab Point.model_name.human(count: 2) do
        render 'points'
      end
      tab Road.model_name.human(count: 2) do
        render 'roads'
      end
    end
  end

  action_item :update_routes, only: :show do
    if can?(:update_routes, BuildingPart)
      link_to I18n.t('my_active_admin.building_part.new_update_routes'),
              new_update_routes_admin_building_part_path(id: resource.id), method: :get,
              data: { confirm: I18n.t('my_active_admin.update_routes.confirm') }
    end
  end

  member_action :new_update_routes, method: :get, title: I18n.t('my_active_admin.building_part.new_update_routes') do
    @building_part_update_routes = BuildingPartUpdateRoutes.new(resource.as_json)
  end

  member_action :update_routes, method: :post do
    presenter = BuildingPartUpdateRoutes.new(params
      .required(:building_part_update_routes))

    response = Client::Buildings::Services::UpdateRoutes.new(resource, presenter).call
    return redirect_to admin_building_part_path(id: resource.id) if response.success?

    @building_part_update_routes = BuildingPartUpdateRoutes.new(resource.as_json)
    flash[:error] = response.message
    render :new_update_routes
  end
end
