# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LoadMap::SvgParser do
  let(:map_with_roads) { File.open('spec/fixtures/map_with_roads.svg', 'r').read }
  let(:map_without_roads) { File.open('spec/fixtures/map_without_roads.svg', 'r').read }

  it { expect(described_class.new(map_with_roads).parse.lines.count).to eq(4) }
  it { expect(described_class.new(map_with_roads).parse.points.count).to eq(5) }

  it { expect { described_class.new(map_without_roads).parse.lines.count }.to raise_error(LoadMap::SvgParserError) }
end
