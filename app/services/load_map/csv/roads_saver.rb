# frozen_string_literal: true
require 'csv'

# Модуль группирует всё необходимое для загрузки карт и маршрутов помещений
module LoadMap
  module Csv
    # Записать Roads в Csv формате
    class RoadsSaver
      attr_reader :roads_csv_file_name

      def initialize(roads_csv_file_name)
        @roads_csv_file_name = roads_csv_file_name
      end

      def save(roads)
        CSV.open(@roads_csv_file_name, 'wb') do |csv_file|
          LoadMap::Csv::RoadsSerializer.new(roads).each do |line_as_array|
            csv_file << line_as_array
          end
        end
      end
    end
  end
end

