# frozen_string_literal: true

# Модуль группирует всё необходимое для загрузки карт и маршрутов помещений
module LoadMap
  # Фабрика для создания классов тегов, на основании данных. полученных из класса SvgTag
  class TagFactory
    TAG_TYPE_TO_CLASS = { line: LoadMap::Line, circle: LoadMap::Point }.freeze

    def self.build(svg_tag)
      raise StandardError, 'TagFactory. Передан nil' unless svg_tag
      raise StandardError, "TagFactory. Неизвестный тег #{svg_tag.tag_type}" unless TAG_TYPE_TO_CLASS[svg_tag.tag_type]

      TAG_TYPE_TO_CLASS[svg_tag.tag_type].new(svg_tag.content)
    end
  end
end
