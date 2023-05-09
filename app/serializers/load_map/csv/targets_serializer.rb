# frozen_string_literal: true

# Модуль группирует всё необходимое для загрузки карт и маршрутов помещений
module LoadMap
  module Csv
    # Сериализатор для коллекции Target
    class TargetsSerializer < Enumerator

      def initialize(*several_variants, targets)
        super(*several_variants) do |y|
          targets.each do |target|
            y << LoadMap::Csv::TargetSerializer.new(target).as_csv
          end
        end
      end
    end
  end
end

