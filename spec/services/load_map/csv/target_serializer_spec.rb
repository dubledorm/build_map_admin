# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LoadMap::Csv::TargetSerializer do
  let(:circle_example) do
    '<circle cx="33.003893" cy="271.761704" fill="none" id="Point1" r="18.413111" stroke="#ea0e0e" '\
'stroke-dasharray="null" stroke-linecap="null" stroke-linejoin="null" stroke-width="5"/>'
  end

  let(:target) { LoadMap::Target.new(LoadMap::Svg::Point.new(circle_example), nil) }
  let(:target1) do
    LoadMap::Target.new(LoadMap::Svg::Point.new(circle_example), { point_type: 'crossroads',
                                                              name: 'name',
                                                              description: 'some, description' })
  end

  it { expect(described_class.new(target).as_csv).to eq(['Point1', 'crossroads', '33003', '271761', '', '']) }
  it { expect(described_class.new(target1).as_csv).to eq(['Point1', 'crossroads', '33003', '271761', 'name', 'some, description']) }
end
