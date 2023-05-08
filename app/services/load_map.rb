# frozen_string_literal: true

# Модуль группирует всё необходимое для загрузки карт и маршрутов помещений
# saver_class - класс, используемый для сохранения данных, полученных из класса LoadRoads
module LoadMap

  def self.setup
    yield self
  end

  mattr_accessor :saver_class

  # Класс ошибки разбора svg файла
  class SvgParserError < StandardError
  end
end
