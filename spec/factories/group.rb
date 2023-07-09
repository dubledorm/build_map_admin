FactoryBot.define do
  factory :group, class: Group do
    sequence(:name) { |n| "name_#{n}" }

    building
    organization
  end
end
