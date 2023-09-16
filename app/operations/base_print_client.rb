# frozen_string_literal: true

# Базовый класс для печати этикетки
class BasePrintClient
  def single_print!(_point, _template_name)
    raise NotImplementedError
  end

  def multiple_print!(_points, _template_name)
    raise NotImplementedError
  end
end
