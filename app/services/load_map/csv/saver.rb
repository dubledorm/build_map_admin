# frozen_string_literal: true
require 'csv'

# Модуль группирует всё необходимое для загрузки карт и маршрутов помещений
module LoadMap
  module Csv
    # Записать Targets и Roads в csv формате
    class Saver
      attr_reader :targets_csv_file_name, :roads_csv_file_name

      def initialize(targets_csv_file_name, roads_csv_file_name)
        @targets_csv_file_name = targets_csv_file_name
        @roads_csv_file_name = roads_csv_file_name
      end

      def save(roads, targets)
        LoadMap::Csv::RoadsSaver.new(roads_csv_file_name).save(roads)
        LoadMap::Csv::TargetsSaver.new(targets_csv_file_name).save(targets)
      end
    end
  end
end

