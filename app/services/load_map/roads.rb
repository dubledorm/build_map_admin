# frozen_string_literal: true

# Модуль группирует всё необходимое для загрузки карт и маршрутов помещений
module LoadMap
  # Класс для обогащения списка lines, полученных из SvgParser идентификаторами точек.
  # Класс построен на основе Enumerator, чтобы не создавать повторный массив lines
  class Roads < Enumerator

    COULD_NOT_FIND_POINT_ID = lambda { |x, y|
      "Не могу найти идентификатор точки для координат x = #{x}, y = #{y}"
    }

    # Билдер, выдаёт объект класса Roads, который лениво отдаёт обогащённые элементы lines
    def self.build(svg_parser)
      new do |y|
        svg_parser.result['LoadMap::Line'].each do |line|
          y << Road.new(line, LoadMap::Roads.find_point_id(svg_parser, line.x1, line.y1),
                        LoadMap::Roads.find_point_id(svg_parser, line.x2, line.y2))
        end
      end
    end

    # Найти идентификатор точки в списке svg_parser.result[LoadMap::Line] по переданным координатам
    def self.find_point_id(svg_parser, point_x, point_y)
      index = svg_parser.result['LoadMap::Point']&.find_index { |point| point.inside_of_me?(point_x, point_y) }
      raise LoadMap::SvgParserError, COULD_NOT_FIND_POINT_ID.call(point_x, point_y) unless index

      svg_parser.result['LoadMap::Point'][index].id
    end
  end
end
