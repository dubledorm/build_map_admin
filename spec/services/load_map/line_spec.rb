# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LoadMap::Line do
  let(:line_example) do
    'fill="none" id="svg_7" stroke="#ea0e0e" stroke-dasharray="null" stroke-linecap="null"'\
' stroke-linejoin="null" stroke-width="5" x1="37.003893" x2="567.003885" y1="271.261708" y2="271.261708"'
  end

  let(:bad_example) { 'fill="none"' }

  it { expect(described_class.new(line_example).x1).to eq(37_003) }
  it { expect(described_class.new(line_example).x2).to eq(567_003) }
  it { expect(described_class.new(line_example).y1).to eq(271_261) }
  it { expect(described_class.new(line_example).y2).to eq(271_261) }

  it { expect { described_class.new(bad_example).x1 }.to raise_error(LoadMap::SvgParserError) }
end
