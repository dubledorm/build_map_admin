class CreateRoad < ActiveRecord::Migration[7.0]
  def change
    create_table :roads do |t|
      t.references :organization, null: false, foreign_key: true
      t.references :building_part, null: false, foreign_key: true
      t.references :point1, null: false, foreign_key: { to_table: 'points' }
      t.references :point2, null: false, foreign_key: { to_table: 'points' }
      t.integer :weight

      t.timestamps
    end
  end
end
