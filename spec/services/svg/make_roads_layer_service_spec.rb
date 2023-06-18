# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Svg::MakeRoadsLayerService do
  let!(:building_part) { FactoryBot.create :building_part }
  let!(:point1) { FactoryBot.create :point, x_value: 1001, y_value: 1002, building_part: building_part, organization: building_part.organization }
  let!(:point2) { FactoryBot.create :point, x_value: 1003, y_value: 1004, building_part: building_part, organization: building_part.organization }
  let!(:road) { FactoryBot.create :road, point1_id: point1.id, point2_id: point2.id, building_part: building_part, organization: building_part.organization  }
  let(:result) do
    "<g class=\"layer\">\n  <title>Roads</title>  <circle cx=\"1.001\" cy=\"1.002\" id=\"#{point1.id}"\
"\"\n r=\"7\" class=\"point_click point_crossroads\"/>\n<circle cx=\"1.003\" cy=\"1.004\" id=\"#{point2.id}"\
"\"\n r=\"7\" class=\"point_click point_crossroads\"/>\n\n  <line class=\"road_svg\"\n x1=\"1.001\"\n"\
" x2=\"1.003\"\n y1=\"1.002\"\n y2=\"1.004\"/>\n\n</g>"
  end

  it {
    expect(described_class.new(building_part.points,
                               building_part.roads).make).to eq(result)
  }
end
