# frozen_string_literal: true

module Svg
  # Удаляет из переданного в svg_string буффера уровень с именем layer_name
  # Возвращает новый string, без этого уровня
  class DropLayerService

    REG_EXP_FIND_LAYER = '\s*<g class="layer">[^<]*<title>{LAYER_NAME}</title>'
    REG_EXP_FIND_END = %r{^\s*</g>}
    def self.drop(svg_string, layer_name)
      reg_exp_find_layer = Regexp.new(REG_EXP_FIND_LAYER.gsub('{LAYER_NAME}', layer_name))

      m_start = reg_exp_find_layer.match(svg_string)
      return svg_string unless m_start

      m_end = REG_EXP_FIND_END.match(svg_string[m_start.begin(0)..])
      raise StandardError, I18n.t('svg.drop_layer_service.dose_not_exists_end_of_tag') unless m_end

      svg_string[0..m_start.begin(0) - 1] + svg_string[m_start.begin(0) + m_end.end(0)..]
    end
  end
end
