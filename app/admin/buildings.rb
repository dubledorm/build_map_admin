ActiveAdmin.register Building do

  permit_params :organization_id, :name, :description, building_parts_attributes: %i[id building_id name description state]
  filter :name

  form title: Building.model_name.human do |f|
    f.semantic_errors *f.object.errors
    inputs I18n.t('admin_menu.attributes') do
      f.input :name
      f.input :description
    end


    f.inputs do
      f.has_many :building_parts, allow_destroy: true do |building_part_form|
        building_part_form.input :name
        building_part_form.input :description
      end
    end

    f.actions
  end

end
