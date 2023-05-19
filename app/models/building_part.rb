# frozen_string_literal: true

# Запись об BuildingPart
class BuildingPart < ApplicationRecord
  validates :name, presence: true

  belongs_to :organization
  belongs_to :building
  has_many :points, dependent: :destroy
  has_many :roads, dependent: :destroy
end
