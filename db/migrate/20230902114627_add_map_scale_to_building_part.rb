class AddMapScaleToBuildingPart < ActiveRecord::Migration[7.0]
  def change
    add_column :building_parts, :map_scale, :integer, default: 10
  end
end
