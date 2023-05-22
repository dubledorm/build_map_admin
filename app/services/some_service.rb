# frozen_string_literal: true

# Для эксперименгтов
class SomeService

  def self.variable1_set(value)
    @variable1 = value
  end

  def self.variable1_get
    @variable1
  end

  def local_variable1_get
    @@variable1
  end

  # TODO Только для экспериментов. Удалить потом
  def create_organization
    Organization.transaction(isolation: :repeatable_read) do
      byebug
      org = Organization.first
      byebug
      org.update(name: "some_name #{Time.now}")
      byebug
    end
  end

  def size(&block)
    return length unless block

    inject(0) { |count, item| block.call(item) ? count + 1 : count }
  end
end

class Range
  def rand
    delta = last - first + 1
    first + Random.rand(delta)
  end
end

