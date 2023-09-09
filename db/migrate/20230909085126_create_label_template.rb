class CreateLabelTemplate < ActiveRecord::Migration[7.0]
  def change
    create_table :label_templates do |t|
      t.string :name

      t.timestamps
    end
  end
end
