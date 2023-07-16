# frozen_string_literal: true

require 'rails_helper'
require 'path_finder/roads_adapter/roads_adapter'
require 'support/hash_entity_builder'

RSpec.describe RoadsAdapter::RoadsAdapter do
  describe 'HashEntityBuilder' do
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
    let(:subject) { described_class.new(roads_example, HashEntityBuilder) }

    it { expect(HashEntityBuilder.new(roads_example[0]).point1_entity.id).to eq(10) }
    it { expect(HashEntityBuilder.new(roads_example[0]).point2_entity.id).to eq(20) }
    it { expect(HashEntityBuilder.new(roads_example[0]).road_entity.source_id).to eq(101) }
    it { expect(HashEntityBuilder.new(roads_example[0]).road_entity.point1_id).to eq(10) }
    it { expect(HashEntityBuilder.new(roads_example[0]).road_entity.point2_id).to eq(20) }
    it { expect(HashEntityBuilder.new(roads_example[0]).road_entity.weight).to eq(1) }

    it { expect(subject.road_entities.count).to eq(5) }
    it { expect(subject.point_entities.count).to eq(4) }

    it { expect(subject.find_point_index(30)).to eq(2) }
    it { expect(subject.find_point_index(40)).to eq(3) }
    it { expect(subject.find_road_index(2, 3, 3)).to eq(2) }
    it {
      expect(subject.road(2)).to eq({ id: 103,
                                      point1_id: 30,
                                      point2_id: 40,
                                      weight: 3 })
    }

    it { expect(subject.point_entity(2).id).to eq(30) }
  end

  describe 'ActiveRecordEntityBuilder' do
    let(:building_part) { FactoryBot.create :building_part }
    let(:roads) { FactoryBot.create_list :road, 10, building_part: }

    let(:subject) { described_class.new(roads, Core::ActiveRecordEntityBuilder) }

    it { expect(Core::ActiveRecordEntityBuilder.new(roads[0]).point1_entity.id).to eq(roads[0].point1_id) }
    it { expect(Core::ActiveRecordEntityBuilder.new(roads[0]).point2_entity.id).to eq(roads[0].point2_id) }
    it { expect(Core::ActiveRecordEntityBuilder.new(roads[0]).road_entity.source_id).to eq(roads[0].id) }
    it { expect(Core::ActiveRecordEntityBuilder.new(roads[0]).road_entity.point1_id).to eq(roads[0].point1_id) }
    it { expect(Core::ActiveRecordEntityBuilder.new(roads[0]).road_entity.point2_id).to eq(roads[0].point2_id) }
    it { expect(Core::ActiveRecordEntityBuilder.new(roads[0]).road_entity.weight).to eq(roads[0].weight) }


    it { expect(subject.road_entities.count).to eq(10) }
    it { expect(subject.point_entities.count).to eq(20) }
    it { expect(subject.point_entities.first.id).to eq(roads.first.point1_id) }
    it { expect(subject.point_entities.second.id).to eq(roads.first.point2_id) }
    it { expect(subject.road_entities.first.weight).to eq(roads.first.weight) }
  end
end
