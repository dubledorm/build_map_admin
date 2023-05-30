FactoryBot.define do
  factory :admin_user, class: AdminUser do
    sequence(:email) { |n| "#{n}@example.com" }
    password { 'password' }
    password_confirmation { 'password' }
    organization
  end

  factory :system_admin, class: AdminUser, parent: :admin_user do
    roles { [association(:role, name: 'system_admin')] }
  end

  factory :system_account_manager, class: AdminUser, parent: :admin_user do
    roles { [association(:role, name: 'system_account_manager')] }
  end

  factory :system_manager, class: AdminUser, parent: :admin_user do
    roles { [association(:role, name: 'system_manager')] }
  end

  factory :client_user, class: AdminUser, parent: :admin_user do
    roles { [association(:role, name: 'client_user')] }
  end

  factory :client_owner, class: AdminUser, parent: :admin_user do
    roles { [association(:role, name: 'client_owner')] }
  end
end
