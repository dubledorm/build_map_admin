# frozen_string_literal: true

# Класс для загрузки xls файла для операции UpdateRoutes.
class BuildingPartUpdateRoutes
  include ActiveModel::Model

  attr_reader :routes_xls

  validates :routes_xls, presence: true

  def initialize(hash_attributes = {})
    self.attributes = hash_attributes
  end

  def attributes=(hash)
    return unless hash

    @routes_xls = hash[:routes_xls]
  end
end
