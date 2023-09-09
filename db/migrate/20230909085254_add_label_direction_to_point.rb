class AddLabelDirectionToPoint < ActiveRecord::Migration[7.0]
  def change
    add_column :points, :label_direction, :string, default: 'none'

    add_index :points, :label_direction
  end
end
