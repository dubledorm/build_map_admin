# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LoadMap::Csv::RoadSerializer do
  let(:line_example) do
    '<line fill="none" id="svg_7" stroke="#ea0e0e" stroke-dasharray="null" stroke-linecap="null"'\
' stroke-linejoin="null" stroke-width="5" x1="37.003893" x2="567.003885" y1="271.261708" y2="271.261708"/>'
  end

  let(:line) { LoadMap::Svg::Line.new(line_example) }
  let(:road) { LoadMap::Road.new(line, 1, 2) }

  it { expect(described_class.new(road).as_csv).to eq(%w[1 2 530000]) }
end
