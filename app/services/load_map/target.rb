# frozen_string_literal: true

# Модуль группирует всё необходимое для загрузки карт и маршрутов помещений
module LoadMap
  # Класс для дополнения класса point дополнительной информацией
  class Target
    include ActiveModel::Validations

    POINT_TYPE_VALUES = %w[crossroads target].freeze
    attr_reader :id, :name, :description, :point_type, :point

    delegate :inside_of_me?, to: :point

    validates :id, :point, presence: true
    validates :point_type, inclusion: { in: POINT_TYPE_VALUES }

    def initialize(point, line_hash = nil)
      @point = point
      @id = point.id || SecureRandom.uuid
      @point_type = 'crossroads'
      line_hash&.keys&.excluding('id')&.each do |key|
        if key == 'point_type'
          instance_variable_set("@#{key}", POINT_TYPE_VALUES.include?(line_hash[key]) ? (line_hash[key]) : 'target')
          next
        end
        instance_variable_set("@#{key}", line_hash[key])
      end

      raise ArgumentError, errors.full_messages unless valid?
    end
  end
end
