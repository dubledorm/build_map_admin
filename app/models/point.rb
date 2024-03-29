# frozen_string_literal: true

# Запись об BuildingPart
class Point < ApplicationRecord
  POINT_TYPE_VALUES = %w[crossroads target].freeze
  LABEL_DIRECTION_VALUES = %w[none up down left right].freeze

  validates :x_value, :y_value, :point_type, presence: true
  validates :point_type, inclusion: { in: POINT_TYPE_VALUES }
  validates :label_direction, inclusion: { in: LABEL_DIRECTION_VALUES }

  belongs_to :organization
  belongs_to :building_part
  has_one :building, through: :building_part
  has_one :point1_roads, foreign_key: 'point1_id', class_name: 'Road'
  has_one :point2_roads, foreign_key: 'point2_id', class_name: 'Road'
  has_and_belongs_to_many :groups, class_name: 'Group', join_table: 'points_groups'

  accepts_nested_attributes_for :groups

  scope :by_name, ->(name_part) { where('points.name like ?', "%#{sanitize_sql_like(name_part)}%") }
  scope :by_group, ->(group_id) { joins(:groups).where(groups: { id: group_id }) }
  scope :targets, -> { where(point_type: :target) }
  scope :qr_code_labels, -> { where('points.label_direction <> ?', 'none') }
  scope :qr_code_label_by_building_part, ->(building_part_id) { qr_code_labels.where(building_part_id:) }
end
