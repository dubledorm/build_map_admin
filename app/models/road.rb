# frozen_string_literal: true

# Запись о дуге между точками
class Road < ApplicationRecord
  ROAD_TYPE_VALUES = %w[staircase road].freeze

  validates :weight, presence: true
  validates :road_type, inclusion: { in: ROAD_TYPE_VALUES }, allow_nil: true

  belongs_to :organization
  belongs_to :building_part
  has_one :building, through: :building_part
  belongs_to :point1, class_name: 'Point', foreign_key: 'point1_id'
  belongs_to :point2, class_name: 'Point', foreign_key: 'point2_id'

  scope :road_only, -> { where('(road_type is NULL) OR (road_type = ?)', 'road') }
  scope :staircase_only, -> { where(road_type: 'staircase') }
end
