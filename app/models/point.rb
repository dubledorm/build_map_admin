# frozen_string_literal: true

# Запись об BuildingPart
class Point < ApplicationRecord
  POINT_TYPE_VALUES = %w[crossroad target].freeze

  validates :x_value, :y_value, :point_type, presence: true
  validates :point_type, inclusion: { in: POINT_TYPE_VALUES }

  belongs_to :organization
  belongs_to :building_part
  has_one :point1_roads, foreign_key: 'point1_id', class_name: 'Road'
  has_one :point2_roads, foreign_key: 'point2_id', class_name: 'Road'
end
