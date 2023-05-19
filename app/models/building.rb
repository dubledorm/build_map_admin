# frozen_string_literal: true

# Запись об Организации в БД
class Building < ApplicationRecord
  validates :name, presence: true

  belongs_to :organization
  has_many :building_parts, dependent: :destroy

  accepts_nested_attributes_for :building_parts, allow_destroy: true
end
