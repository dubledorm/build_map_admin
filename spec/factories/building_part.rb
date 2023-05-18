FactoryBot.define do
  factory :building_part, class: BuildingPart do
    sequence(:name) { |n| "building_part name #{n}" }
    organization
    building
  end
end
