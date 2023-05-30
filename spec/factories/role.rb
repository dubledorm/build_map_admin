FactoryBot.define do
  factory :role, class: Role do
    name { 'client_owner' }
    admin_user
  end
end
