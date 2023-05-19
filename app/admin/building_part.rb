ActiveAdmin.register BuildingPart do

  permit_params :building_id, :organization_id, :name, :description
  filter :name
end
