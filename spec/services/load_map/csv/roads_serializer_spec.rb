# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LoadMap::Csv::RoadsSerializer do
  let(:map_with_roads) { File.open('spec/fixtures/map_with_roads.svg', 'r').read }
  let(:svg_parser) { LoadMap::Svg::SvgParser.new(map_with_roads, [LoadMap::Svg::Line, LoadMap::Svg::Point]).parse }
  let(:roads) { LoadMap::Roads.new(svg_parser.result['LoadMap::Svg::Line'], nil) }
  let(:find_point_id_mocks) do
    [[35_003, 350_261, 'Point4'],
     [37_003, 271_261, 'Point1'],
     [567_003, 271_261, 'Point2'],
     [570_003, 349_261, 'Point3'],
     [29_003, 268_261, 'Point1'],
     [294_003, 74_261, 'Point5'],
     [566_003, 263_261, 'Point2'],
     [296_003, 66_261, 'Point5']].freeze
  end

  before :each do
    allow_any_instance_of(LoadMap::Roads).to receive(:find_point_id).and_raise(LoadMap::SvgParserError)
    find_point_id_mocks.each do |example|
      allow_any_instance_of(LoadMap::Roads).to receive(:find_point_id).with(example[0], example[1]).and_return(example[2])
    end
  end

  it { expect(described_class.new(roads).take(1)).to eq([%w[Point1 Point2 530000]]) }
end
