# frozen_string_literal: true

# Декоратор для LabelTemplate
class LabelTemplateDecorator < Draper::Decorator
  delegate_all

  DEFAULT_TEMPLATE_TYPE_VALUE = 'undefined'

  def template_type
    I18n.t("label_template.template_type.#{object.template_type || DEFAULT_TEMPLATE_TYPE_VALUE}")
  end

  def self.template_types
    LabelTemplate::TEMPLATE_TYPE_VALUES.map { |type_value| [I18n.t("label_template.template_type.#{type_value}"), type_value] }
  end
end
