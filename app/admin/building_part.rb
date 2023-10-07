ActiveAdmin.register BuildingPart do
  menu parent: 'building'
  permit_params :building_id, :name, :description, :state, :original_map, :map_scale, :building_part_update_routes,
                :level
  actions :index, :show, :edit, :update, :destroy
  filter :building, collection: proc { Building.accessible_by(current_ability) }
  filter :name
  filter :state, as: :check_boxes,
                 collection: proc { BuildingPartDecorator.states }
  filter :level
  filter :created_at
  filter :updated_at

  decorate_with BuildingPartDecorator

  index do
    id_column
    column :building
    column :name
    column :state
    column :description
    column :level
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
      f.input :level
      panel I18n.t('my_active_admin.building_part.original_map') do
        f.file_field :original_map
      end
      f.input :map_scale
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
        row :level
        row :description
        row :map_scale
        row :created_at
        row :updated_at
      end
    end

    tabs do
      tab I18n.t('my_active_admin.building_part.map') do
        render 'original_map'
      end
      tab I18n.t('my_active_admin.building_part.immutable_map') do
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
    flash[:error] = response.message[0..250]
    render :new_update_routes
  end

  action_item :new_print_labels, only: :show do
    if can?(:new_print_labels, BuildingPart)
      link_to I18n.t('my_active_admin.building_part.new_print_labels'),
              new_print_labels_admin_building_part_path(id: resource.id), method: :get
    end
  end

  member_action :new_print_labels, method: :get, title: I18n.t('my_active_admin.building_part.new_print_labels') do
    @multiple_label_print_presenter = MultipleLabelPrintPresenter.new(resource.as_json)
  end

  member_action :print_labels, method: :post do
    @multiple_label_print_presenter = MultipleLabelPrintPresenter.new(params.required(:multiple_label_print_presenter))
    return render :new_print_labels unless @multiple_label_print_presenter.valid?

    template_name = LabelTemplate.find(@multiple_label_print_presenter.template_label_id).relation_name
    response = Client::Buildings::Services::PrintMultipleLabel.new.call(Point.qr_code_label_by_building_part(resource.id),
                                                                        template_name)
    if response.success?
      return send_data response.result, filename: 'label.pdf', type: 'application/pdf', disposition: 'attachment'
    end

    flash[:error] = response.message[0..250]
    render :new_print_labels
  end

end
