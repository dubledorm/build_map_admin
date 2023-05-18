# frozen_string_literal: true

# Запись о дуге между точками
class Road < ApplicationRecord

  validates :weight, presence: true

  belongs_to :organization
  belongs_to :building_part
  belongs_to :point1, class_name: 'Point', foreign_key: 'point1_id'
  belongs_to :point2, class_name: 'Point', foreign_key: 'point2_id'
end
