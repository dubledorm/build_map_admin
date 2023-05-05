# frozen_string_literal: true

# Модуль группирует всё необходимое для загрузки карт и маршрутов помещений
module LoadMap
  # Класс для обогащения списка circles, полученных из SvgParser данными из xls файла.
  # Класс построен на основе Enumerator, чтобы не создавать повторный массив circles
  class Targets < Enumerator

    XLS_FIELDS_ORDER = %w[id point_type name description].freeze

    attr_reader :xls_lines

    def initialize(*several_variants, svg_parser, xls_file_path)
      super(*several_variants) do |y|
        svg_parser.result['LoadMap::Point'].each do |point|
          y << Target.new(point, find_xls_line(point.id))
        end
      end

      read_workbook(xls_file_path)
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
      index = @xls_lines.find_index { |line_hash| line_hash['id'] == id }
      return nil unless index

      @xls_lines[index]
    end
  end
end
