# frozen_string_literal: true

# Класс, выполняющий проверки по списку правил
# Функция check_rules возвращаем массив ошибок, найденный в ходе проверок
# Если массив пустой, то значит все проверки пройдены успешно
class RuleList < Enumerator

  attr_reader :errors

  def initialize(*several_variants, rules)
    @errors = []
    super(*several_variants) do |y|
      rules.each do |rule|
        y << rule
      end
    end
  end

  def valid?(checked_data)
    rewind
    @errors.clear

    each do |rule|
      next if rule.valid?(checked_data)

      @errors << rule.message
    end

    @errors.empty?
  end
end
