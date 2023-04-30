# frozen_string_literal: true

# Модуль группирует всё необходимое для загрузки карт и маршрутов помещений
module LoadMap
  # Базовый класс для создания классов тегов
  class BaseTag

    NORMALIZE_RANGE = 3 # До скольки знаков обрезать дробную часть координат
    def initialize(tag_str)
      tag_str_parse(tag_str)
    rescue StandardError => e
      raise LoadMap::SvgParserError, "Ошибка разбора строки #{tag_str}. Ошибка: #{e.message}"
    end

    def self.str_start_with_me?(_str)
      raise NotImplementedError
    end

    def length
      raise NotImplementedError
    end

    def content
      raise NotImplementedError
    end

    protected

    def tag_str_parse(_str)
      raise NotImplementedError
    end

    def normalize_coordinate(coordinate_str)
      parts = coordinate_str.split('.')
      parts[1] = parts[1][0..NORMALIZE_RANGE - 1]
      parts.join('').to_i
    end
  end
end
