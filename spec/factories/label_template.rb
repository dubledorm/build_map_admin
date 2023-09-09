FactoryBot.define do
  factory :label_template, class: LabelTemplate do
    sequence(:name) { |n| "name_#{n}" }
    template_type { :single }
  end
end
