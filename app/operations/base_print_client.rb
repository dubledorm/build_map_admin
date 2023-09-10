# frozen_string_literal: true

# Базовый класс для печати этикетки
class BasePrintClient
  def initialize(template_name)
    @template_name = template_name
  end

  def single_print!(_point)
    raise NotImplementedError
  end

  def multiple_print!(_points)
    raise NotImplementedError
  end
end
