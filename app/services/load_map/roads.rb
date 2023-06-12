# frozen_string_literal: true

# Модуль группирует всё необходимое для загрузки карт и маршрутов помещений
module LoadMap
  # Класс для обогащения списка lines, полученных из SvgParser идентификаторами точек.
  # Класс построен на основе Enumerator, чтобы не создавать повторный массив lines
  # В качестве параметров конструктора передаётся эксземпляр SvgParser, у которого
  # уже должен быть выполнен вызов метода parse, result_key - ключ, по которому в svg_parser.result
  # нужно искать массив линий, и класс, предоставляющий функцию find_point_id - поиск идентификатора точки
  # по её координатам
  class Roads < Enumerator
    attr_reader :point_finder

    delegate :find_point_id, to: :point_finder

    def initialize(*several_variants, lines, point_finder)
      super(*several_variants) do |y|
        lines.each do |line|
          y << Road.new(line, find_point_id(line.x1, line.y1), find_point_id(line.x2, line.y2))
        end
      end

      @point_finder = point_finder
    end
  end
end
