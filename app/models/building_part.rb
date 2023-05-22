# frozen_string_literal: true

# Запись об BuildingPart
class BuildingPart < ApplicationRecord
  validates :name, presence: true

  belongs_to :organization
  belongs_to :building
  has_many :points, dependent: :destroy, before_add: :add_organization_to_point
  has_many :roads, dependent: :destroy, before_add: :add_organization_to_road

  private

  def add_organization_to_point(point)
    point.organization_id = organization_id
  end

  def add_organization_to_road(point)
    point.organization_id = organization_id
  end
end
