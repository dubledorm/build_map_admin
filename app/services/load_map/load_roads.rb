# frozen_string_literal: true

# Модуль группирует всё необходимое для загрузки карт и маршрутов помещений
module LoadMap
  # сервис для загрузки маршрутов для конкретного помещения.
  class LoadRoads
    attr_reader :targets, :roads

    KNOWN_TAG_CLASSES = [LoadMap::Line, LoadMap::Point].freeze
    def initialize(source_svg_path, source_xls_path)
      @source_svg_path = source_svg_path
      @source_xls_path = source_xls_path
    end

    def done
      svg_parser = SvgParser.new(File.open(@source_svg_path, 'r').read, KNOWN_TAG_CLASSES).parse
      @targets = Targets.new(svg_parser.result['LoadMap::Point'], @source_xls_path)
      @roads = Roads.new(svg_parser.result['LoadMap::Line'], self)
    end

    # Найти идентификатор точки в списке targets по переданным координатам
    def find_point_id(point_x, point_y)
      @targets.each_entry { |target| return target.id if target.inside_of_me?(point_x, point_y) }
      raise LoadMap::SvgParserError, COULD_NOT_FIND_POINT_ID.call(point_x, point_y)
    end

    private

    def save_result
      LoadMap.saver_class.new.save
    end
  end
end

