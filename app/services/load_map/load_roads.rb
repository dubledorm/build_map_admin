# frozen_string_literal: true

# Модуль группирует всё необходимое для загрузки карт и маршрутов помещений
module LoadMap
  # сервис загрузки маршрутов для конкретного помещения.
  class LoadRoads
    attr_reader :targets, :roads

    # Массив известных тегов
    KNOWN_TAG_CLASSES = [LoadMap::Svg::Line, LoadMap::Svg::Point].freeze

    COULD_NOT_FIND_POINT_ID = lambda { |x, y|
      I18n.t('load_map.load_roads.could_not_find_point_id', x:, y:)
    }

    def initialize(source_svg, source_xls, saver)
      @source_svg = source_svg
      @source_xls = source_xls
      @saver = saver
    end

    def self.build_from_file(source_svg_path, source_xls_path, saver)
      source_svg = File.open(source_svg_path, 'r', &:read)
      source_xls = File.open(source_xls_path, 'rb', &:read)
      new(source_svg, source_xls, saver)
    end

    def done
      svg_parser = LoadMap::Svg::SvgParser.new(@source_svg, KNOWN_TAG_CLASSES).parse
      @targets = Targets.new(svg_parser.result['LoadMap::Svg::Point'], @source_xls)
      @roads = Roads.new(svg_parser.result['LoadMap::Svg::Line'], self)
      save_result
    end

    # Найти идентификатор точки в списке targets по переданным координатам
    def find_point_id(point_x, point_y)
      @targets.each_entry { |target| return target.id if target.inside_of_me?(point_x, point_y) }
      raise LoadMap::SvgParserError, COULD_NOT_FIND_POINT_ID.call(point_x, point_y)
    end

    private

    def save_result
      @saver.save(@roads, @targets)
    end
  end
end

