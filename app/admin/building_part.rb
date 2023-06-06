ActiveAdmin.register BuildingPart do
  permit_params :building_id, :name, :description, :state
  actions :index, :show, :edit, :update, :destroy
  filter :name

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
    end

    f.actions
  end
end
