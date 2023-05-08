# frozen_string_literal: true

# Модуль группирует всё необходимое для загрузки карт и маршрутов помещений
module LoadMap
  # Класс для обогащения списка points (Point), данными из xls файла.
  # В качестве параметров принимает массив points и маршрут к xls файлу с дополнительными данными
  # Записи в xls файле должны находиться на 1-й странице, начиная со второй строки
  # Порядок следования полей определён в массиве XLS_FIELDS_ORDER
  class Targets < Enumerator

    # Этот массив содержит порядок следования полей в xls файле
    XLS_FIELDS_ORDER = %w[id point_type name description].freeze

    attr_reader :xls_lines

    def initialize(*several_variants, points, xls_file_path)
      super(*several_variants) do |y|
        @targets.each do |target|
          y << target
        end
      end

      read_workbook(xls_file_path)
      @targets = points.map { |point| Target.new(point, find_xls_line(point.id))}
    end

    def read_workbook(xls_file_path)
      @xls_lines = []
      @workbook = RubyXL::Parser.parse(xls_file_path)
      @workbook.worksheets[0][1..].each do |row|
        @xls_lines << read_line(row)
      end
    end

    def read_line(row)
      Hash[*row&.cells&.each_with_index&.map { |cell, index| [XLS_FIELDS_ORDER[index], cell.value] }.flatten]
    end

    def find_xls_line(id)
      return nil unless id

      index = @xls_lines.find_index { |line_hash| line_hash['id'] == id }
      return nil unless index

      @xls_lines[index]
    end
  end
end
