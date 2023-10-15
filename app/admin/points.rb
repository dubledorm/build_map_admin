ActiveAdmin.register Point do
  permit_params :name, :description, :point_type, :x_value, :y_value, :label_direction,
                group_ids: []
  decorate_with PointDecorator
  includes :organization, :building, :building_part
  menu false

  form title: Point.model_name.human do |f|
    f.semantic_errors *f.object.errors
    inputs do
      f.input :name
      f.input :point_type, as: :select, collection: PointDecorator.point_types
      f.input :groups, as: :select, input_html: { multiple: true }
      f.input :x_value
      f.input :y_value
      f.input :description, as: :text
      f.input :label_direction, as: :select, collection: PointDecorator.label_directions
    end

    f.actions
  end

  show do
    panel Point.model_name.human do
      attributes_table_for point do
        row :organization
        row :building
        row :building_part
        row :name
        row :point_type
        row :x_value
        row :y_value
        row :description
        row :label_direction
        row :created_at
        row :updated_at
      end
    end

    panel Group.model_name.human(count: 3) do
      table_for resource.groups do
        column :name
        column :description
        column :created_at
        column :updated_at
      end
    end

    panel Road.model_name.human(count: 3) do
      table_for Road.by_point_id(resource.id).decorate do
        column :road_type
        column :weight
        column :exit_map_direction1
        column :exit_map_direction2
        column :created_at
        column :updated_at
        column do |road|
          link_to I18n.t('my_active_admin.road.show'), admin_building_road_path(building_id: road.building.id,
                                                                                id: road.id)
        end
      end
    end

    panel I18n.t('my_active_admin.building_part.original_map') do
      external_svg(smart_map(resource.building_part, resource))
    end
  end

  action_item :new_print_label, only: :show do
    if can?(:new_print_label, Point)
      link_to I18n.t('my_active_admin.building_part.points.new_print_label'),
              new_print_label_admin_point_path(id: resource.id), method: :get
    end
  end

  member_action :new_print_label, method: :get, title: I18n.t('my_active_admin.building_part.points.new_print_label') do
    @single_label_print_presenter = SingleLabelPrintPresenter.new(resource.as_json)
  end

  member_action :print_label, method: :post do
    @single_label_print_presenter = SingleLabelPrintPresenter.new(params.required(:single_label_print_presenter))
    return render :new_print_label unless @single_label_print_presenter.valid?

    template_name = LabelTemplate.find(@single_label_print_presenter.template_label_id).relation_name
    response = Client::Buildings::Services::PrintSingleLabel.new.call(resource, template_name)
    if response.success?
      return send_data response.result, filename: 'label.pdf', type: 'application/pdf', disposition: 'attachment'
    end

    flash[:error] = response.message[0..250]
    render :new_print_label
  end
end
