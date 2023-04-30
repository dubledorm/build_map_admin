LoadMap.setup do |config|
  [LoadMap::Line, LoadMap::Point].each do |tag_class|
    config.known_tag_classes << tag_class
  end
end