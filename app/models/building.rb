# frozen_string_literal: true

# Запись об Организации в БД
class Building < ApplicationRecord
  validates :name, presence: true

  belongs_to :organization
  has_many :building_parts, dependent: :destroy, before_add: :add_organization_to_building_part
  has_many :points, through: :building_parts

  accepts_nested_attributes_for :building_parts, allow_destroy: true

  private

  def add_organization_to_building_part(building_part)
    building_part.organization_id = organization_id
  end
end
