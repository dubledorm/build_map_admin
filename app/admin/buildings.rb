ActiveAdmin.register Building do
  menu parent: 'building'
  permit_params :name, :description,
                building_parts_attributes: %i[id building_id name description state _destroy],
                groups_attributes: %i[id name description _destroy]
  filter :name

  form title: Building.model_name.human do |f|
    f.semantic_errors *f.object.errors
    inputs do
      f.input :name
      f.input :description, as: :text
    end


    f.inputs do
      f.has_many :building_parts, allow_destroy: true do |building_part_form|
        building_part_form.input :name
        building_part_form.input :description, as: :text
      end
    end

    f.inputs do
      f.has_many :groups, allow_destroy: true do |group_form|
        group_form.input :name
        group_form.input :description, as: :text
      end
    end

    f.actions
  end

  show do
    panel Building.model_name.human do
      attributes_table_for building do
        row :name
        row :description
        row :organization
        row :created_at
        row :updated_at
      end
    end

    panel BuildingPart.model_name.human do
      table_for resource.building_parts do
        column :name
        column :description
        column :created_at
        column :updated_at
        column '' do |building_part|
          link_to I18n.t('my_active_admin.building.show'), admin_building_part_path(id: building_part.id)
        end
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
  end

  action_item :new_interfloor_road, only: :show do
    if can?(:new_interfloor_road, Building)
      link_to I18n.t('my_active_admin.building.new_interfloor_road'),
              new_admin_building_road_path(building_id: resource.id), method: :get
    end
  end
end
