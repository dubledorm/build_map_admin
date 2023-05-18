ActiveAdmin.register Building do

  permit_params :organization_id, :name, :description
  #
  # or
  #
  # permit_params do
  #   permitted = [:organization_id, :name, :description]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
end
