# frozen_string_literal: true

module Svg
  # Добавляет в строку с svg картинкой ещё один уровень - Roads
  # Возвращает новый string, с этим уровнем
  class AddRoadsLayerService
    def self.add(svg_string, roads_layer)
      start_index = svg_string.rindex('</g>')
      raise StandardError, I18n.t('my_active_admin.add_roads_layer_service.not_found_layer') unless start_index

      svg_string[0..start_index + 3] + "\n#{roads_layer}\n" + svg_string[start_index + 4..]
    end
  end
end
