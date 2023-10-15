# frozen_string_literal: true

module Core
  module Routes
    module Services
      # Базовый класс для составления словесного описания маршрута
      class BaseSpeaker
        attr_reader :length_m

        NORMALIZE_RANGE = Settings.svg_file.normalize_coordinate_limit # До скольки знаков обрезать дробную часть координат
        # Делитель для перевода веса дуги в длину в метрах
        DIVIDER_M = Array.new(NORMALIZE_RANGE) { 10 }.inject(1) { |result, item| result * item }

        def initialize(point1_hash, point2_hash, road_hash, current_direction, map_scale)
          @point1_hash = point1_hash
          @point2_hash = point2_hash
          @road_hash = road_hash
          @current_direction = current_direction
          @length_m = road_hash[:weight] / (DIVIDER_M * map_scale) if @road_hash
        end

        def map_direction
          raise NotImplementedError
        end

        def user_direction
          raise NotImplementedError
        end

        def legend
          raise NotImplementedError
        end
      end
    end
  end
end
