# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LoadMap::Point do
  let(:circle_example) do
    '<circle cx="33.003893" cy="271.761704" fill="none" id="Point1" r="18.413111" stroke="#ea0e0e" '\
'stroke-dasharray="null" stroke-linecap="null" stroke-linejoin="null" stroke-width="5"/>'
  end

  let(:bad_example) { '' }

  it { expect(described_class.str_start_with_me?(bad_example)).to be_falsy }
  it { expect(described_class.str_start_with_me?(circle_example)).to be_truthy }
  it { expect(described_class.new(circle_example).x1).to eq(33_003) }
  it { expect(described_class.new(circle_example).y1).to eq(271_761) }
  it { expect(described_class.new(circle_example).r).to eq(18_413) }
  it { expect(described_class.new(circle_example).id).to eq('Point1') }

  it { expect { described_class.new(bad_example).x1 }.to raise_error(LoadMap::SvgParserError) }
end
