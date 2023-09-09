# frozen_string_literal: true

# Шаблон для печати этикеток
class LabelTemplate < ApplicationRecord

  TEMPLATE_TYPE_VALUES = %w[single multiple].freeze

  validates :name, :relation_name, presence: true
  validates :template_type, inclusion: { in: TEMPLATE_TYPE_VALUES }
end
