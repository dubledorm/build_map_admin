# frozen_string_literal: true

# Запись об Организации в БД
class Building < ApplicationRecord
  validates :name, presence: true

  belongs_to :organization
  has_many :building_parts
end
