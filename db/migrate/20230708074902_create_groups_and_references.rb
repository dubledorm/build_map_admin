class CreateGroupsAndReferences < ActiveRecord::Migration[7.0]
  def change
    create_table :groups do |t|
      t.string :name
      t.string :description
      t.references :building, null: false, foreign_key: true

      t.timestamps
    end

    create_table :points_groups, id: false do |t|
      t.references :group, null: false, foreign_key: true
      t.references :point, null: false, foreign_key: true

      t.timestamps
    end
  end
end
