# frozen_string_literal: true

# Класс, определяющий один элемент списка правил.
# Содержит само правило rule_class, являющееся настледником от BaseRule и message, которое должно быть вовзращенио в
# случае не выполнения правила
class RuleListItem
  attr_accessor :rule_class, :message

  def initialize(rule_class, message)
    @rule_class = rule_class
    @message = message
  end

  def valid?(checked_object)
    rule_class.valid?(checked_object)
  end
end
