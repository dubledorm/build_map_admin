class CreatePoint < ActiveRecord::Migration[7.0]
  def change
    create_table :points do |t|
      t.references :organization, null: false, foreign_key: true
      t.references :building_part, null: false, foreign_key: true
      t.string :point_type
      t.string :name
      t.string :description
      t.integer :x_value
      t.integer :y_value

      t.timestamps
    end
  end
end
