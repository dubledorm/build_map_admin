# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LoadMap::Targets do
  let(:xls_file_path) { 'spec/fixtures/BuildMapInfo.xlsx' }
  let(:map_with_roads) { File.open('spec/fixtures/map_with_roads.svg', 'r').read }
  let(:svg_parser) { LoadMap::Svg::SvgParser.new(map_with_roads, [LoadMap::Svg::Line, LoadMap::Svg::Point]).parse }
  let(:targets) { described_class.new(svg_parser.result['LoadMap::Svg::Point'], xls_file_path) }

  it { expect(described_class.new(svg_parser.result['LoadMap::Svg::Point'], xls_file_path ).xls_lines.count).to eq(5) }
  it { expect(described_class.new(svg_parser.result['LoadMap::Svg::Point'], xls_file_path).xls_lines[4]).to eq({ 'description' => 'Пиво, чипсы, телевизоры', 'id' => 'Point5', 'name' => '"Всё для футбола"', 'point_type' => 'shop' }) }

  it { expect(targets.next.id).to eq('Point1') }
  it { expect(targets.next.point_type).to eq('shop') }

  it 'use some next calls' do
    targets.next
    target = targets.next
    expect(target.id).to eq('Point4')
    expect(target.point_type).to eq('crossroads')
  end

  it 'should generate exception StopIteration' do
    5.times { targets.next }
    expect { targets.next }.to raise_error(StopIteration)
  end

  it { expect(targets.map(&:id)).to eq(%w[Point1 Point4 Point2 Point3 Point5]) }

  context 'when some id is absent' do
    let(:xls_file_path) { 'spec/fixtures/BuildMapInfo.xlsx' }
    let(:map_with_roads) { File.open('spec/fixtures/map_with_circles_without_id.svg', 'r').read }
    let(:svg_parser) { LoadMap::Svg::SvgParser.new(map_with_roads, [LoadMap::Svg::Line, LoadMap::Svg::Point]).parse }
    let(:targets) { described_class.new(svg_parser.result['LoadMap::Svg::Point'], xls_file_path) }

    it { expect(targets.next.id).to_not be_nil }
  end
end
