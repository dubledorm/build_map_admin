# frozen_string_literal: true

# Модуль группирует всё необходимое для загрузки карт и маршрутов помещений
module LoadMap
  module Svg
    # Базовый класс для создания классов тегов
    class BaseTag

      NORMALIZE_RANGE = 3 # До скольки знаков обрезать дробную часть координат
      def initialize(tag_str)
        tag_str_parse(tag_str)
      rescue StandardError => e
        raise LoadMap::SvgParserError, "Ошибка разбора строки. Ошибка: #{e.message}. Строка:  #{tag_str[0..250]}."
      end

      # Возвращает true если строка _str начинается с этого тега
      def self.str_start_with_me?(_str)
        raise NotImplementedError
      end

      # Возвращает длину строки тега. По ней будет происходить обрезка входной строки, чтобы искать следующий тег
      def length
        raise NotImplementedError
      end

      # Сожержимое тега. Используется при выводе ошибок разбора
      def content
        raise NotImplementedError
      end

      protected

      # Основная функция разбирающая тег и получающая все необходимые параметры из него
      def tag_str_parse(_str)
        raise NotImplementedError
      end

      def normalize_coordinate(coordinate_str)
        parts = coordinate_str.split('.')
        parts << '0' if parts.size < 2
        parts[1] = parts[1][0..NORMALIZE_RANGE - 1]
        parts.join('').to_i
      end
    end
  end
end
