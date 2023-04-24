# frozen_string_literal: true

# Модуль группирует всё необходимое для загрузки карт и маршрутов помещений
module LoadMap
  # Базовый класс для создания классов тегов
  class BaseTag

    def initialize(tag_str)
      tag_str_parse(tag_str)
    end


    protected

    def tag_str_parse(_tag_str)
      throw NotImplementedError
    end
  end
end
