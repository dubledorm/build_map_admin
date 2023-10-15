# frozen_string_literal: true

# Запись о дуге между точками
class Road < ApplicationRecord
  ROAD_TYPE_VALUES = %w[staircase road].freeze
  EXIT_MAP_DIRECTION_VALUES = %w[up down left right].freeze

  validates :weight, presence: true
  validates :road_type, inclusion: { in: ROAD_TYPE_VALUES }, allow_nil: true
  validates :exit_map_direction1, inclusion: { in: EXIT_MAP_DIRECTION_VALUES }, allow_nil: true
  validates :exit_map_direction2, inclusion: { in: EXIT_MAP_DIRECTION_VALUES }, allow_nil: true

  belongs_to :organization
  belongs_to :building_part
  has_one :building, through: :building_part
  belongs_to :point1, class_name: 'Point', foreign_key: 'point1_id'
  belongs_to :point2, class_name: 'Point', foreign_key: 'point2_id'

  scope :road_only, -> { where('(road_type is NULL) OR (road_type = ?)', 'road') }
  scope :staircase_only, -> { where(road_type: 'staircase') }
  scope :by_point_id, ->(point_id) { includes(:building).where('(point1_id = ?) or (point2_id = ?)', point_id, point_id) }
end
