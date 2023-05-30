class AddOrganisationToAdminUser < ActiveRecord::Migration[7.0]
  def change
    AdminUser.destroy_all
    add_reference :admin_users, :organization, null: false, foreign_key: true
  end
end
