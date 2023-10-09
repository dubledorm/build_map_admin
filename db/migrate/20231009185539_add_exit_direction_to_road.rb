class AddExitDirectionToRoad < ActiveRecord::Migration[7.0]
  def change
    add_column :roads, :exit_map_direction1, :string
    add_column :roads, :exit_map_direction2, :string
  end
end
