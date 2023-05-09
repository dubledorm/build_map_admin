# frozen_string_literal: true

# Модуль группирует всё необходимое для загрузки карт и маршрутов помещений
module LoadMap
  module Svg
    # Найденный в svg файле тег line
    class UnknownTag < BaseTag

      attr_reader :length, :content

      def self.str_start_with_me?(_str)
        true
      end

      protected

      def tag_str_parse(str)
        @content = str.lstrip[0..20]
        @length = 0
      end
    end
  end
end
