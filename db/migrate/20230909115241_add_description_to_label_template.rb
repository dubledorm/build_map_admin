class AddDescriptionToLabelTemplate < ActiveRecord::Migration[7.0]
  def change
    LabelTemplate.delete_all
    add_column :label_templates, :description, :text
    add_column :label_templates, :template_type, :string, null: false
  end
end
