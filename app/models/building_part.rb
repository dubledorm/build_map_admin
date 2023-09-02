# frozen_string_literal: true

# Запись об BuildingPart
class BuildingPart < ApplicationRecord
  STATE_VALUES = %w[draft working].freeze

  before_validation do
    self.state ||= 'draft'
  end

  validates :name, presence: true
  validates :state, inclusion: { in: STATE_VALUES }
  validates :map_scale, numericality: { only_integer: true, greater_than: 0 }

  belongs_to :organization
  belongs_to :building
  has_many :roads, dependent: :destroy, before_add: :add_organization_to_road
  has_many :points, dependent: :destroy, before_add: :add_organization_to_point

  has_one_attached :original_map # Карта с маршрутами
  has_one_attached :immutable_map # Карта без маршрутов

  private

  def add_organization_to_point(point)
    point.organization_id = organization_id
  end

  def add_organization_to_road(point)
    point.organization_id = organization_id
  end
end
