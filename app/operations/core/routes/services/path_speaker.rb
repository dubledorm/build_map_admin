# frozen_string_literal: true

module Core
  module Routes
    module Services
      # Вернуть словесное описание маршрута между двумя точками, а также направление
      # Расчёты ведутся от положения начала координат в левом верхнем углу карты
      class PathSpeaker
        attr_reader :legend, :user_direction, :map_direction, :length_m

        NORMALIZE_RANGE = Settings.svg_file.normalize_coordinate_limit # До скольки знаков обрезать дробную часть координат
        DIRECTION_VALUES = %i[left right up down finish].freeze
        UP_CORNER_TN = 1 # Тангенс угла от оси Х до линии, отделяющей верхний сектор
        # Делитель для перевода веса дуги в длину в метрах
        DIVIDER_M =  Array.new(NORMALIZE_RANGE) { 10 }.inject(1) { |result, item| result * item }

        # Массив для применения поправки на текущее направление
        CURRENT_DIRECTION_MAP = [{ current_direction: :up, direction: :up, result: :forward },
                                 { current_direction: :up, direction: :right, result: :right },
                                 { current_direction: :up, direction: :left, result: :left },
                                 { current_direction: :up, direction: :down, result: :backward },
                                 { current_direction: :right, direction: :up, result: :left },
                                 { current_direction: :right, direction: :right, result: :forward },
                                 { current_direction: :right, direction: :left, result: :backward },
                                 { current_direction: :right, direction: :down, result: :right },
                                 { current_direction: :left, direction: :up, result: :right },
                                 { current_direction: :left, direction: :right, result: :backward },
                                 { current_direction: :left, direction: :left, result: :forward },
                                 { current_direction: :left, direction: :down, result: :left },
                                 { current_direction: :down, direction: :up, result: :backward },
                                 { current_direction: :down, direction: :right, result: :left },
                                 { current_direction: :down, direction: :left, result: :right },
                                 { current_direction: :down, direction: :down, result: :forward }].freeze

        LEGEND_MAP = { forward: ->(length) { "Двигайтесь прямо #{length} метров" },
                       right: ->(length) { "Поверните на право и пройдите #{length} метров" },
                       left: ->(length) { "Поверните на лево и пройдите #{length} метров" },
                       backward: ->(length) { "Поверните назад и пройдите #{length} метров" },
                       finish: ->(_) { 'Вы пришли' } }.freeze
        def initialize(point1_hash, point2_hash, weight, current_direction, map_scale)
          @point1_hash = point1_hash
          @point2_hash = point2_hash
          @current_direction = current_direction
          @length_m = weight / (DIVIDER_M * map_scale)
          @legend = LEGEND_MAP[user_direction]&.call(@length_m)
        end

        def map_direction
          @map_direction ||= calc_map_direction
        end

        def user_direction
          @user_direction ||= direction_map(map_direction)
        end

        private

        def calc_map_direction
          return :finish if @point2_hash.nil?

          length_y, length_x, x_otr = calc_init

          if length_y.positive?
            return :up if length_x.abs < x_otr
            return :right if length_x.positive?

            return :left
          end

          return :down if length_x.abs < x_otr
          return :right if length_x.positive?

          :left
        end

        def calc_init
          length_y = -1 * (@point2_hash[:y_value] - @point1_hash[:y_value])
          length_x = @point2_hash[:x_value] - @point1_hash[:x_value]

          x_otr = (UP_CORNER_TN * length_y).abs

          [length_y, length_x, x_otr]
        end

        def direction_map(direction)
          return :finish if direction == :finish

          CURRENT_DIRECTION_MAP.find do |item|
            item[:current_direction] == @current_direction && item[:direction] == direction
          end&.dig(:result)
        end
      end
    end
  end
end
