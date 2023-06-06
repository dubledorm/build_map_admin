# frozen_string_literal: true

# Декоратор для BuildingPart
class BuildingPartDecorator < Draper::Decorator
  delegate_all

  DEFAULT_STATE_VALUE = 'undefined'

  def state
    I18n.t("building_part.state.#{object.state || DEFAULT_STATE_VALUE}")
  end

  def self.states
    BuildingPart::STATE_VALUES.map { |state_value| [I18n.t("building_part.state.#{state_value}"), state_value] }
  end
end
