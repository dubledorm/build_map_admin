# frozen_string_literal: true

# Запись об Организации в БД
class Organization < ApplicationRecord
  validates :name, presence: true

  has_many :buildings
  has_many :building_parts
end
