# frozen_string_literal: true

# Запись об Организации в БД
class Organization < ApplicationRecord
  validates :name, presence: true
end
