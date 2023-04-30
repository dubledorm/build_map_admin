# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LoadMap::SvgParser do
  let(:map_with_roads) { File.open('spec/fixtures/map_with_roads.svg', 'r').read }
  let(:map_without_roads) { File.open('spec/fixtures/map_without_roads.svg', 'r').read }
  let(:map_with_unknown_tag) { File.open('spec/fixtures/map_with_unknown_tag.svg', 'r').read }

  it { expect(described_class.new(map_with_roads).parse.result['LoadMap::Line'].count).to eq(4) }
  it { expect(described_class.new(map_with_roads).parse.result['LoadMap::Line'].map(&:x1)).to eq([37_003, 35_003, 29_003, 566_003]) }
  it { expect(described_class.new(map_with_roads).parse.result['LoadMap::Point'].count).to eq(5) }
  it { expect(described_class.new(map_with_roads).parse.result['LoadMap::Point'].map(&:id)).to eq(%w[Point1 Point4 Point2 Point3 Point5]) }

  it { expect { described_class.new(map_without_roads).parse.result['LoadMap::Line'].count }.to raise_error(LoadMap::SvgParserError) }
  it { expect { described_class.new(map_with_unknown_tag).parse.result['LoadMap::Line'].count }.to raise_error(LoadMap::SvgParserError) }
end
