FactoryBot.define do
  factory :label_template, class: LabelTemplate do
    sequence(:name) { |n| "name_#{n}" }
    sequence(:relation_name) { |n| "relation_name_#{n}" }
    template_type { :single }
  end
end
