# frozen_string_literal: true

ActiveAdmin.register LabelTemplate do
  permit_params :name, :template_type, :description, :relation_name
  decorate_with LabelTemplateDecorator

  filter :name
  filter :template_type, as: :select, collection: proc { LabelTemplateDecorator.template_types }
  filter :relation_name

  index do
    id_column
    column :name
    column :template_type
    column :relation_name
    column :description
    column :created_at
    column :updated_at
    actions
  end

  form title: LabelTemplate.model_name.human do |f|
    f.semantic_errors *f.object.errors
    inputs do
      f.input :name
      f.input :template_type, as: :select, collection: LabelTemplateDecorator.template_types
      f.input :relation_name
      f.input :description, as: :text
    end

    f.actions
  end
end
