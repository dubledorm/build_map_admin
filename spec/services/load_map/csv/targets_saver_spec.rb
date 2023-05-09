# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LoadMap::Csv::TargetsSaver do
  let(:xls_file_path) { 'spec/fixtures/BuildMapInfo.xlsx' }
  let(:map_with_roads) { File.open('spec/fixtures/map_with_roads.svg', 'r').read }
  let(:svg_parser) { LoadMap::SvgParser.new(map_with_roads, [LoadMap::Line, LoadMap::Point]).parse }
  let(:targets) { LoadMap::Targets.new(svg_parser.result['LoadMap::Point'], xls_file_path) }
  let(:result_csv_file_path) { 'spec/fixtures/result_targets_csv_example.csv' }

  it { expect(targets.map(&:id)).to eq(%w[Point1 Point4 Point2 Point3 Point5]) }
  it 'should write to file' do
    ::Dir::Tmpname.create('targets_csv') do |file_path|
      described_class.new(file_path).save(targets)
      expect(File.open(file_path, 'r').read).to eq(File.open(result_csv_file_path, 'r').read)
    end
  end
end
