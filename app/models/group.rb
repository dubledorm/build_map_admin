# frozen_string_literal: true

# Запись о группе
class Group < ApplicationRecord

  validates :name, presence: true

  belongs_to :building
  has_and_belongs_to_many :points, join_table: 'points_groups'
  belongs_to :organization
end
