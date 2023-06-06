# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Svg::NormalizeService do
  let(:svg_with_view_box) { File.open('spec/fixtures/svg/with_view_box.svg', 'r').read }
  let(:result) { File.open('spec/fixtures/svg/result_with_view_box.svg', 'r').read }

  it { expect(described_class.call(svg_with_view_box)).to eq(result) }
end
