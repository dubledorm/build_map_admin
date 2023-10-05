class AddLevelToBuildingPart < ActiveRecord::Migration[7.0]
  def change
    add_column :building_parts, :level, :integer, default: 1
  end
end
