ActiveAdmin.register Building do
  menu parent: :manage_building
  permit_params :name, :description,
                building_parts_attributes: %i[id building_id name description state _destroy]
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
  end

end
