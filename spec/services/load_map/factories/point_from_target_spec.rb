# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LoadMap::Factories::PointFromTarget do
  let(:circle_example) do
    '<circle cx="33.003893" cy="271.761704" fill="none" id="Point1" r="18.413111" stroke="#ea0e0e" '\
'stroke-dasharray="null" stroke-linecap="null" stroke-linejoin="null" stroke-width="5"/>'
  end

  let(:target) { LoadMap::Target.new(LoadMap::Svg::Point.new(circle_example), { name: 'point_name', description: 'description' }) }

  it { expect(described_class.build(target).is_a?(Point)).to be_truthy }
  it {
    expect(described_class.build(target).as_json).to eq({ 'building_part_id' => nil,
                                                          'created_at' => nil,
                                                          'description' => 'description',
                                                          'id' => nil,
                                                          'name' => 'point_name',
                                                          'organization_id' => nil,
                                                          'point_type' => 'crossroads',
                                                          'updated_at' => nil,
                                                          'x_value' => 33_003,
                                                          'y_value' => 271_761 })
  }
end
