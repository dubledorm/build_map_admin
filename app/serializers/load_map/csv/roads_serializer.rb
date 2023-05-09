# frozen_string_literal: true

# Модуль группирует всё необходимое для загрузки карт и маршрутов помещений
module LoadMap
  module Csv
    # Сериализатор для коллекции Road
    class RoadsSerializer < Enumerator

      def initialize(*several_variants, roads)
        super(*several_variants) do |y|
          roads.each do |road|
            y << LoadMap::Csv::RoadSerializer.new(road).as_csv
          end
        end
      end
    end
  end
end

