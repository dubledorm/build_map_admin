FactoryBot.define do
  factory :building, class: Building do
    sequence(:name) { |n| "building name #{n}" }
    organization
  end
end
