# frozen_string_literal: true

# Модуль группирует всё необходимое для загрузки карт и маршрутов помещений
module LoadMap

  def self.setup
    yield self
  end

  mattr_accessor :saver_class
end
