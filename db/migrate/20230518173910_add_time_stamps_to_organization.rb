class AddTimeStampsToOrganization < ActiveRecord::Migration[7.0]
  def change
    Organization.delete_all
    change_table :organizations do |t|
      t.timestamps
    end
  end
end
