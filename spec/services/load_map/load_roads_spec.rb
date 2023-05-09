# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LoadMap::LoadRoads do
  let(:svg_file_path) { 'spec/fixtures/map_with_roads.svg' }
  let(:xls_file_path) { 'spec/fixtures/BuildMapInfo.xlsx' }
  let(:saver) { double('saver') }
  let(:roads_load) { described_class.new(svg_file_path, xls_file_path, saver) }

  describe 'build targets and roads' do
    before :each do
      allow(saver).to receive(:save)
      roads_load.done
    end

    it { expect(roads_load.roads.map(&:start_id)).to eq(%w[Point1 Point4 Point1 Point2]) }
    it { expect(roads_load.targets.map(&:id)).to eq(%w[Point1 Point4 Point2 Point3 Point5]) }
  end

  describe 'saver' do
    it 'should call saver' do
      expect(saver).to receive(:save)

      roads_load.done
    end
  end

  describe 'save to csv' do
    let(:result_targets_name) { ::Dir::Tmpname.create('targets_csv') {} }
    let(:result_roads_name) { ::Dir::Tmpname.create('roads_csv') {} }
    let(:saver) { LoadMap::Csv::Saver.new(result_targets_name, result_roads_name) }
    let(:result_targets_csv_file_path) { 'spec/fixtures/result_targets_csv_example.csv' }
    let(:result_roads_csv_file_path) { 'spec/fixtures/result_roads_csv_example.csv' }

    it 'should save both files' do
      roads_load.done

      expect(File.open(result_targets_name, 'r').read).to eq(File.open(result_targets_csv_file_path, 'r').read)
      expect(File.open(result_roads_name, 'r').read).to eq(File.open(result_roads_csv_file_path, 'r').read)
    end
  end
end
