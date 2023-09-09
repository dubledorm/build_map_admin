class AddRelationNameToLabelTemplate < ActiveRecord::Migration[7.0]
  def change
    LabelTemplate.delete_all
    add_column :label_templates, :relation_name, :string, null: false
  end
end
