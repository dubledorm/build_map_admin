class RolifyCreateRoles < ActiveRecord::Migration[7.0]
  def change
    create_table(:roles) do |t|
      t.string :name
      t.references :admin_user

      t.timestamps
    end

    add_index(:roles, :name)
  end
end
