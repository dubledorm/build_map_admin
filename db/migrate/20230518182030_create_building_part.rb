class CreateBuildingPart < ActiveRecord::Migration[7.0]
  def change
    create_table :building_parts do |t|
      t.references :building, null: false, foreign_key: true
      t.references :organization, null: false, foreign_key: true
      t.string :state
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
