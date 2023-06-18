# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Svg::AddRoadsLayerService do
  let(:svg) do
    '<?xml version="1.0"?>
<svg width="977" height="445" xmlns="http://www.w3.org/2000/svg" xmlns:svg="http://www.w3.org/2000/svg">
 <g class="layer">
  <title>Layer 1</title>
  <rect fill="#5C5858" height="61" id="svg_1" width="36" x="329" y="234"/>
</g>
</svg>'
  end

  let(:svg_wrong) do
    '<?xml version="1.0"?>
<svg width="977" height="445" xmlns="http://www.w3.org/2000/svg" xmlns:svg="http://www.w3.org/2000/svg">
  <rect fill="#5C5858" height="61" id="svg_1" width="36" x="329" y="234"/>
</svg>'
  end


  let(:roads_layer) do
    '<g class="layer">
  <title>Roads</title>
  <circle cx="65.503891" cy="38.761712" fill="none" id="room_220" r="13.892444" stroke="#dd1616" stroke-width="5"/>
  <line fill="none" id="svg_223" stroke="#dd1616" stroke-dasharray="null" stroke-linecap="null" stroke-linejoin="null" stroke-width="5" x1="109.50389" x2="105.50389" y1="35.261712" y2="119.26171"/>
 </g>'
  end

  let(:result) do
    '<?xml version="1.0"?>
<svg width="977" height="445" xmlns="http://www.w3.org/2000/svg" xmlns:svg="http://www.w3.org/2000/svg">
 <g class="layer">
  <title>Layer 1</title>
  <rect fill="#5C5858" height="61" id="svg_1" width="36" x="329" y="234"/>
</g>
<g class="layer">
  <title>Roads</title>
  <circle cx="65.503891" cy="38.761712" fill="none" id="room_220" r="13.892444" stroke="#dd1616" stroke-width="5"/>
  <line fill="none" id="svg_223" stroke="#dd1616" stroke-dasharray="null" stroke-linecap="null" stroke-linejoin="null" stroke-width="5" x1="109.50389" x2="105.50389" y1="35.261712" y2="119.26171"/>
 </g>

</svg>'
  end

  it { expect(described_class.add(svg, roads_layer)).to eq(result) }
  it { expect { described_class.add(svg_wrong, roads_layer) }.to raise_error(StandardError) }
end
