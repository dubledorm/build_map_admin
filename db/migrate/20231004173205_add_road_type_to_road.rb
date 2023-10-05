class AddRoadTypeToRoad < ActiveRecord::Migration[7.0]
  def change
    add_column :roads, :road_type, :string
  end
end
