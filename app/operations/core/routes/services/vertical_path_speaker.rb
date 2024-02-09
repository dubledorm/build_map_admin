# frozen_string_literal: true

module Core
  module Routes
    module Services
      # Вернуть словесное описание маршрута между двумя вертикальными точками, а также направление
      # Расчёты ведутся от положения начала координат в левом верхнем углу карты
      class VerticalPathSpeaker < BaseSpeaker

        DIRECTION_VALUES = %i[walk_up walk_down].freeze



        LEGEND_MAP = { walk_up: ->(floor) { "Поднимитесь на #{floor} этаж" },
                       walk_down: ->(floor) { "Спуститесь на #{floor} этаж" } }.freeze

        def map_direction
          @map_direction ||= calc_map_direction
        end

        def user_direction
          @user_direction ||= vertical_direction
        end

        def legend
          @legend ||= LEGEND_MAP[vertical_direction]&.call(@target_level)
        end

        private

        def calc_map_direction
          return :finish if @point2_hash.nil?

          # В зависимости от того с какой стороны проходим дугу выбираем направление выхода
          return @road_hash[:exit_map_direction2]&.to_sym if @point1_hash[:id] == @road_hash[:point1_id]

          @road_hash[:exit_map_direction1]&.to_sym
        end

        def vertical_direction
          return @vertical_direction if @vertical_direction

          point1 = Point.find(@point1_hash[:id])
          point2 = Point.find(@point2_hash[:id])

          @target_level = point2.building_part.level
          @vertical_direction = point1.building_part.level < point2.building_part.level ? :walk_up : :walk_down
        end
      end
    end
  end
end
