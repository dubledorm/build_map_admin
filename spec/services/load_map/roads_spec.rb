# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LoadMap::Roads do
  let(:map_with_roads) { File.open('spec/fixtures/map_with_roads.svg', 'r').read }
  let(:svg_parser) { LoadMap::SvgParser.new(map_with_roads, [LoadMap::Line, LoadMap::Point]).parse }
  let(:roads) { described_class.new(svg_parser.result['LoadMap::Line'], nil) }
  let(:find_point_id_mocks) do
    [[35_003, 350_261, 'Point4'],
     [37_003, 271_261, 'Point1'],
     [567_003, 271_261, 'Point2'],
     [570_003, 349_261, 'Point3'],
     [29_003, 268_261, 'Point1'],
     [294_003, 74_261, 'Point5'],
     [566_003, 263_261, 'Point2'],
     [296_003, 66_261, 'Point5']
    ].freeze
  end

  before :each do
    allow_any_instance_of(described_class).to receive(:find_point_id).and_raise(LoadMap::SvgParserError)
    find_point_id_mocks.each do |example|
      allow_any_instance_of(described_class).to receive(:find_point_id).with(example[0], example[1]).and_return(example[2])
    end
  end

  it { expect { roads.find_point_id(1, 2) }.to raise_error(LoadMap::SvgParserError) }
  it { expect(roads.find_point_id(35_003, 350_261)).to eq('Point4') }
  it { expect(roads.next.start_id).to eq('Point1') }
  it { expect(roads.next.end_id).to eq('Point2') }
  it 'use some next calls' do
    roads.next
    road = roads.next
    expect(road.start_id).to eq('Point4')
    expect(road.end_id).to eq('Point3')
  end

  it 'should generate exception StopIteration' do
    4.times { roads.next }
    expect { roads.next }.to raise_error(StopIteration)
  end

  it { expect(roads.map(&:start_id)).to eq(%w[Point1 Point4 Point1 Point2]) }
end
