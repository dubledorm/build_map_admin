# frozen_string_literal: true

# Модуль группирует всё необходимое для загрузки карт и маршрутов помещений
module LoadMap
  # Найденный в svg файле очередной тег
  class SvgTag
    include ActiveModel::Model

    TAG_TYPES = %i[circle line layer unknown].freeze

    attr_accessor :length, :tag_type, :content

    validates :tag_type, presence: true
    validates :tag_type, inclusion: { in: TAG_TYPES }
  end
end
