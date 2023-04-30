# frozen_string_literal: true

# Модуль группирует всё необходимое для загрузки карт и маршрутов помещений
# Массив known_tag_classes - Сюда можно добавлять новые классы для расширения коллекции находимых тегов
# Например:
# LoadMap.setup do |config|
#   [LoadMap::Line, LoadMap::Point].each do |tag_class|
#     config.known_tag_classes << tag_class
#   end
# end
module LoadMap

  def self.setup
    yield self
  end

  mattr_accessor :saver_class
  mattr_accessor :known_tag_classes

  self.known_tag_classes = []

  # Класс ошибки разбора svg файла
  class SvgParserError < StandardError
  end
end
