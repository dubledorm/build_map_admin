# frozen_string_literal: true

# Базовый класс для создания правил, которые могут соединяться в RuleList
# Основная задача, наличие функции valid?, которая переопределяется в наследниках
class BaseRule
  # Функция должна возвращать true, если проверяемый объект (checked_data, передаётся в виде hash) удовлетворяет правилу
  # Иначе false
  def self.valid?(_checked_data = {})
    raise NotImplementedError
  end
end
