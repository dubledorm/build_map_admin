ActiveAdmin.register Point do
  permit_params :name, :description, :point_type, :x_value, :y_value, :label_direction,
                group_ids: []
  decorate_with PointDecorator

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
        row :building_part
        row :organization
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

    panel Group.model_name.human do
      table_for resource.groups do
        column :name
        column :description
        column :created_at
        column :updated_at
      end
    end

    panel I18n.t('my_active_admin.building_part.original_map') do
      external_svg(smart_map(resource.building_part, resource))
    end
  end
end
