# frozen_string_literal: true

# Модуль группирует всё необходимое для загрузки карт и маршрутов помещений
module LoadMap
  # сервис для загрузки маршрутов для конкретного помещения.
  class LoadBuildRoads
    def initialize(source_svg_path, source_xls_path)
      @source_svg_path = source_svg_path
      @source_xls_path = source_xls_path
    end

    def done
      file_parse
    end

    private

    attr_reader :targets, :points

    def file_parse

    end

    def save_result
      LoadMap.saver_class.new.save
    end
  end
end

