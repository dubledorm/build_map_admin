FactoryBot.define do
  factory :admin_user, class: AdminUser do
    sequence(:email) { |n| "#{n}@example.com" }
    password { 'password' }
    password_confirmation { 'password' }
    organization
  end

  factory :system_admin, class: AdminUser, parent: :admin_user do
    #roles { [association(:role, name: 'system_admin')] }
    after(:build) do |user|
      user.roles << FactoryBot.build(:role, name: 'system_admin')
    end
  end

  factory :system_account_manager, class: AdminUser, parent: :admin_user do
    #   roles { [association(:role, name: 'system_account_manager')] }
    after(:build) do |user|
      user.roles << FactoryBot.build(:role, name: 'system_account_manager')
    end
  end

  factory :system_manager, class: AdminUser, parent: :admin_user do
    #   roles { [association(:role, name: 'system_manager')] }
    after(:build) do |user|
      user.roles << FactoryBot.build(:role, name: 'system_manager')
    end
  end

  factory :client_user, class: AdminUser, parent: :admin_user do
    #roles { [association(:role, name: 'client_user')] }
    after(:build) do |user|
      user.roles << FactoryBot.build(:role, name: 'client_user')
    end
  end

  factory :client_owner, class: AdminUser, parent: :admin_user do
    # roles { [association(:role, name: 'client_owner')] }
    after(:build) do |user|
      user.roles << FactoryBot.build(:role, name: 'client_owner')
    end
  end

  factory :client_owner_client_user, class: AdminUser, parent: :admin_user do
    #  roles { [association(:role, name: 'client_owner'), association(:role, name: 'client_user')] }
    after(:build) do |user|
      user.roles << FactoryBot.build(:role, name: 'client_owner')
      user.roles << FactoryBot.build(:role, name: 'client_user')
    end
  end

  factory :client_owner_account_manager, class: AdminUser, parent: :admin_user do
    #  roles { [association(:role, name: 'client_owner'), association(:role, name: 'system_account_manager')] }
    after(:build) do |user|
      user.roles << FactoryBot.build(:role, name: 'client_owner')
      user.roles << FactoryBot.build(:role, name: 'system_account_manager')
    end
  end
end
