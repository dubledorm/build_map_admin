# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Organization.transaction do
  Organization.create!(name: 'owner')
  user = AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password', organization: Organization.first)

  Role.create!(name: 'system_admin', admin_user_id: user.id)
  Role.create!(name: 'system_account_manager', admin_user_id: user.id)
end
