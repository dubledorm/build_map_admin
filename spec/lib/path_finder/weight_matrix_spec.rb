# frozen_string_literal: true

require 'rails_helper'
require 'path_finder/weight_matrix'
require 'path_finder/roads_adapter/roads_adapter'
require 'support/hash_entity_builder'

RSpec.describe WeightMatrix do
  let!(:roads_example) do
    [{ id: 101,
       point1_id: 10,
       point2_id: 20,
       weight: 1 },
     { id: 102,
       point1_id: 20,
       point2_id: 30,
       weight: 2 },
     { id: 103,
       point1_id: 30,
       point2_id: 40,
       weight: 3 },
     { id: 104,
       point1_id: 40,
       point2_id: 10,
       weight: 4 },
     { id: 105,
       point1_id: 20,
       point2_id: 40,
       weight: 10 }]
  end
  DIMENSION = 4

  let(:subject) { described_class.new(RoadsAdapter::RoadsAdapter.new(roads_example, HashEntityBuilder)) }

  it { expect(subject.weight(0, 0)).to eq(0) }
  it { expect(subject.weight(DIMENSION - 1, DIMENSION - 1)).to eq(0) }
  it { expect(subject.weight(0, 1)).to eq(1) }
  it { expect(subject.weight(1, 2)).to eq(2) }
  it { expect(subject.weight(2, 3)).to eq(3) }
  it { expect(subject.weight(3, 0)).to eq(4) }
  it { expect(subject.weight(1, 3)).to eq(10) }
  it { expect(subject.weight(3, 1)).to eq(10) }
  it { expect(subject.weight(0, 3)).to eq(4) }
  it { expect(subject.weight(3, 2)).to eq(3) }
  it { expect(subject.weight(2, 1)).to eq(2) }
  it { expect(subject.weight(1, 0)).to eq(1) }
  it { expect(subject.weight(2, 0)).to eq(PathFinderConst::UNAVAILABLE) }
end
