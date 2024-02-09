# frozen_string_literal: true

require 'rails_helper'
require 'path_finder/path_finder'
require 'path_finder/roads_adapter/roads_adapter'
require 'support/hash_entity_builder'

RSpec.describe PathFinder do
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
       weight: 1 },
     { id: 106,
       point1_id: 30,
       point2_id: 50,
       weight: 3 }]
  end

  let!(:subject) { described_class.new(RoadsAdapter::RoadsAdapter.new(roads_example, HashEntityBuilder)) }

  it { expect(subject.path_storage.paths).to eq([[], [], [], [], []]) }
  it { expect(subject.find(10, 20)).to eq([101]) }
  it { expect(subject.find(10, 30)).to eq([101, 102]) }
  it { expect(subject.find(40, 20)).to eq([105]) }
  it { expect(subject.find(10, 10)).to eq([]) }
  it { expect(subject.find(10, 50)).to eq([101, 102, 106]) }
  it { expect { subject.find(101, 1000) }.to raise_error(StandardError) }
end
