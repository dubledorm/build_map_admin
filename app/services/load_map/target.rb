# frozen_string_literal: true

# Модуль группирует всё необходимое для загрузки карт и маршрутов помещений
module LoadMap
  # Класс для дополнения класса point дополнительной инфлормацией
  class Target

    attr_reader :name, :description, :point_type, :point

    delegate :id, to: :point

    def initialize(point, line_hash)
      @point = point
      line_hash.keys.excluding('id').each do |key|
        instance_variable_set("@#{key}", line_hash[key])
      end
    end
  end
end
