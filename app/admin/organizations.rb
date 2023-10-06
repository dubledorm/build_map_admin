# frozen_string_literal: true

ActiveAdmin.register Organization do
  menu parent: 'additional'
  permit_params :name

  filter :name

  index do
    id_column
    column :name
    column :created_at
    column :updated_at
    actions
  end
end
