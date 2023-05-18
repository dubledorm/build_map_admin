# frozen_string_literal: true

# Запись об BuildingPart
class BuildingPart < ApplicationRecord
  validates :name, presence: true

  belongs_to :organization
  belongs_to :building
  has_many :points
end
