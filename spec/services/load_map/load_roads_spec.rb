# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LoadMap::LoadRoads do
  let(:svg_file_path) { 'spec/fixtures/map_with_roads.svg' }
  let(:xls_file_path) { 'spec/fixtures/BuildMapInfo.xlsx' }
  let(:roads_load) { described_class.new(svg_file_path, xls_file_path) }

  before :each do
    roads_load.done
  end

  it { expect(roads_load.roads.map(&:start_id)).to eq(%w[Point1 Point4 Point1 Point2]) }
end
