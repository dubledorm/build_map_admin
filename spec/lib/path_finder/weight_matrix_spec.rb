# frozen_string_literal: true

require 'rails_helper'
require 'path_finder/weight_matrix'
require 'path_finder/points_enumerator'

RSpec.describe WeightMatrix do
  DIMENSION = 5

  let!(:building_part) { FactoryBot.create :building_part }
  let!(:roads) { FactoryBot.create_list :road, DIMENSION }
  let!(:roads_enumerator) { PointsEnumerator.new(roads) }
  let(:subject) { described_class.new(roads, roads_enumerator) }

  it { expect(subject.weight(0, 0)).to eq(0) }
  it { expect(subject.weight(DIMENSION - 1, DIMENSION - 1)).to eq(0) }
end
