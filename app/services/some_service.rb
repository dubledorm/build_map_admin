# frozen_string_literal: true

# Для эксперименгтов
class SomeService
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
end
