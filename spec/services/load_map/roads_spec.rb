# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LoadMap::Roads do
  let(:map_with_roads) { File.open('spec/fixtures/map_with_roads.svg', 'r').read }
  let(:svg_parser) { LoadMap::SvgParser.new(map_with_roads).parse }
  let(:roads) { described_class.build(svg_parser) }

  before :each do
    LoadMap.setup do |config|
      [LoadMap::Line, LoadMap::Point].each do |tag_class|
        config.known_tag_classes << tag_class
      end
    end
  end

  it { expect { described_class.find_point_id(svg_parser, 1, 2) }.to raise_error(LoadMap::SvgParserError) }
  it { expect(described_class.find_point_id(svg_parser, 35_003, 350_261)).to eq('Point4') }
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

  # it 'experiment' do
  #   roads.each do |road|
  #     puts "EXTERN: #{road.start_id}"
  #   end
  # end
end
