ActiveAdmin.register BuildingPart do

  permit_params :building_id, :name, :description, :state
  filter :name

  decorate_with BuildingPartDecorator

  form do |f|
    f.semantic_errors *f.object.errors
    f.inputs do
      f.input :name
      f.input :description, as: :text
      f.input :state, as: :select, collection: BuildingPartDecorator.states
    end

    f.actions
  end
end
