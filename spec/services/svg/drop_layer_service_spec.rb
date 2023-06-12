# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Svg::DropLayerService do
  let(:svg_with_roads_layer) { File.open('spec/fixtures/drop_layer_service/map_with_roads_layer.svg', 'r').read }
  let(:result) { File.open('spec/fixtures/drop_layer_service/map_without_roads_layer.svg', 'r').read }
  let(:svg_without_end_layer) { File.open('spec/fixtures/drop_layer_service/bad_map_with_roads_layer.svg', 'r').read }

  it { expect(described_class.drop(svg_with_roads_layer, 'Roads')).to eq(result) }
  it { expect { described_class.drop(svg_without_end_layer, 'Roads') }.to raise_error(StandardError) }
end
