# frozen_string_literal: true

require 'rails_helper'
require 'path_finder/path_storage'
require 'path_finder/roads_adapter/roads_adapter'
require 'support/hash_entity_builder'

RSpec.describe PathStorage do
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

  let(:subject) { described_class.new(RoadsAdapter::RoadsAdapter.new(roads_example, HashEntityBuilder)) }

  it { expect(subject.paths).to eq([[], [], [], []]) }

  it 'add' do
    path_storage = subject
    path_storage.add(0, 1)
    expect(path_storage.paths[1]).to eq([0])

    path_storage.add(2, 1)
    expect(path_storage.paths).to eq([[], [0, 2], [], []])
  end

  it 'replace' do
    path_storage = subject
    path_storage.add(0, 1)
    path_storage.add(2, 1)
    path_storage.add(3, 2)
    path_storage.add(4, 2)
    expect(path_storage.paths).to eq([[], [0, 2], [3, 4], []])

    path_storage.replace(1, [4, 1])
    expect(path_storage.paths).to eq([[], [4, 1], [3, 4], []])
  end
end
