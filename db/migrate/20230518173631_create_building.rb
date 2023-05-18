class CreateBuilding < ActiveRecord::Migration[7.0]
  def change
    create_table :buildings do |t|
      t.references :organization, null: false, foreign_key: true
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
