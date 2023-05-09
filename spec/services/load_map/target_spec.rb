# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LoadMap::Target do
  let(:circle_example) do
    '<circle cx="33.003893" cy="271.761704" fill="none" id="Point1" r="18.413111" stroke="#ea0e0e" '\
'stroke-dasharray="null" stroke-linecap="null" stroke-linejoin="null" stroke-width="5"/>'
  end

  let(:circle_without_id_example) do
    '<circle cx="33.003893" cy="271.761704" fill="none" r="18.413111" stroke="#ea0e0e" '\
'stroke-dasharray="null" stroke-linecap="null" stroke-linejoin="null" stroke-width="5"/>'
  end

  it { expect(described_class.new(LoadMap::Svg::Point.new(circle_example), nil).id).to eq('Point1') }

  it { expect(described_class.new(LoadMap::Svg::Point.new(circle_without_id_example), nil).id).to_not be_nil }
end
