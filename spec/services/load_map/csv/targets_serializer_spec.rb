# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LoadMap::Csv::TargetsSerializer do
  let(:xls_file_path) { 'spec/fixtures/BuildMapInfo.xlsx' }
  let(:map_with_roads) { File.open('spec/fixtures/map_with_roads.svg', 'r').read }
  let(:svg_parser) { LoadMap::Svg::SvgParser.new(map_with_roads, [LoadMap::Svg::Line, LoadMap::Svg::Point]).parse }
  let(:targets) { LoadMap::Targets.new(svg_parser.result['LoadMap::Svg::Point'], xls_file_path) }

  it { expect(targets.map(&:id)).to eq(%w[Point1 Point4 Point2 Point3 Point5]) }
  it { expect(described_class.new(targets).take(1)).to eq([["Point1", "shop", "33003", "271761", "Секс шоп \"Гей, мальчишки!\"", "Нужные и полезные товары для красоты и здоровья"]]) }
end
