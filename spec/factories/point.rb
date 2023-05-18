FactoryBot.define do
  factory :point, class: Point do
    sequence(:name) { |n| "point name #{n}" }
    sequence(:x_value) { |n| n }
    sequence(:y_value) { |n| n }
    organization
    building_part
    point_type { 'crossroad' }
  end
end
