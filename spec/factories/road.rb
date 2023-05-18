FactoryBot.define do
  factory :road, class: Road do
    sequence(:weight) { |n| n }
    organization
    building_part
    point1 factory: :point
    point2 factory: :point
  end
end
