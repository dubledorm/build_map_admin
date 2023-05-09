# frozen_string_literal: true
require 'csv'

# Модуль группирует всё необходимое для загрузки карт и маршрутов помещений
module LoadMap
  module Csv
    # Записать Targets в Csv формате
    class TargetsSaver
      attr_reader :targets_csv_file_name

      def initialize(targets_csv_file_name)
        @targets_csv_file_name = targets_csv_file_name
      end

      def save(targets)
        CSV.open(@targets_csv_file_name, 'wb') do |csv_file|
          LoadMap::Csv::TargetsSerializer.new(targets).each do |line_as_array|
            csv_file << line_as_array
          end
        end
      end
    end
  end
end

