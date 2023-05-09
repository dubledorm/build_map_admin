FactoryGirl.define do
  factory :organization, class: Organization do
    sequence(:name) { |n| "organization name #{n}" }
  end
end
