# frozen_string_literal: true

# Модуль группирует всё необходимое для загрузки карт и маршрутов помещений
module LoadMap
  # сервис для загрузки маршрутов для конкретного помещения.
  class LoadRoads
    def initialize(source_svg_path, source_xls_path)
      @source_svg_path = source_svg_path
      @source_xls_path = source_xls_path
    end

    def done
      svg_parser = SvgParser.new(File.open(@source_svg_path, 'r').read).parse
      @roads = Roads.build(svg_parser)
      @targets = Targets.build(svg_parser)
    end

    private

    attr_reader :targets, :roads

    def save_result
      LoadMap.saver_class.new.save
    end
  end
end

