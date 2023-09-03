# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Core::Routes::Services::FindPath do
  let(:building_part) { FactoryBot.create :building_part }

  describe 'roads' do
    let(:roads) { FactoryBot.create_list :road, 10, building_part: }
    let(:road_ids) { [roads[3].id, roads[0].id, roads[4].id, roads[5].id] }
    let(:subject) { described_class.new(building_part.building_id, roads[3].point1_id, roads[5].point2_id) }

    before :each do
      allow(Point).to receive(:find).and_return(Point.new(building_part:))
      allow_any_instance_of(Point).to receive(:building).and_return(building_part.building)
      allow_any_instance_of(described_class).to receive(:find_road_ids).and_return(road_ids)
      subject.send(:init)
    end

    it do
      result = []
      fiber = subject.send(:build_roads_fiber)
      5.times do
        result << fiber.resume
      end

      expect(result.map { |road| road&.dig(:id) }).to eq(road_ids << nil)
    end
  end

  describe 'build_point_and_weight_array' do
    let(:roads_fiber) do
      Fiber.new do
        index = 0
        loop do
          Fiber.yield roads_fiber_result[index]
          index += 1
        end
      end
    end

    let(:subject) { described_class.new(building_part.building_id, 1, 5) }

    before :each do
      allow(Point).to receive(:find).and_return(Point.new(building_part:))
      allow_any_instance_of(Point).to receive(:building).and_return(building_part.building)
      subject.send(:init)
    end

    context 'when first element order is true' do
      let!(:roads_fiber_result) do
        [{ id: 1, point1_id: 1, point2_id: 2, weight: 1 },
         { id: 2, point1_id: 3, point2_id: 2, weight: 2 },
         { id: 3, point1_id: 3, point2_id: 4, weight: 3 },
         { id: 4, point1_id: 5, point2_id: 4, weight: 4 },
         nil]
      end

      it do
        point_and_weight_array = subject.send(:build_point_and_weight_array, roads_fiber)
        expect(point_and_weight_array).to eq([{ point_id: 1, weight: 1 },
                                              { point_id: 2, weight: 2 },
                                              { point_id: 3, weight: 3 },
                                              { point_id: 4, weight: 4 },
                                              { point_id: 5, weight: 0 }])
      end
    end

    context 'when first element order is false' do
      let!(:roads_fiber_result) do
        [{ id: 1, point1_id: 2, point2_id: 1, weight: 1 },
         { id: 2, point1_id: 3, point2_id: 2, weight: 2 },
         { id: 3, point1_id: 3, point2_id: 4, weight: 3 },
         { id: 4, point1_id: 5, point2_id: 4, weight: 4 },
         nil]
      end

      it do
        point_and_weight_array = subject.send(:build_point_and_weight_array, roads_fiber)
        expect(point_and_weight_array).to eq([{ point_id: 1, weight: 1 },
                                              { point_id: 2, weight: 2 },
                                              { point_id: 3, weight: 3 },
                                              { point_id: 4, weight: 4 },
                                              { point_id: 5, weight: 0 }])
      end
    end
  end

  describe 'find' do
    let!(:points) { FactoryBot.create_list :point, 10, building_part: }
    let!(:road1) { FactoryBot.create :road, building_part:, point1_id: points[0].id, point2_id: points[1].id, weight: 10_000 }
    let!(:road2) { FactoryBot.create :road, building_part:, point1_id: points[1].id, point2_id: points[2].id, weight: 20_000 }
    let!(:road3) { FactoryBot.create :road, building_part:, point1_id: points[2].id, point2_id: points[3].id, weight: 30_000 }
    let!(:road4) { FactoryBot.create :road, building_part:, point1_id: points[3].id, point2_id: points[4].id, weight: 40_000 }
    let(:subject) { described_class.new(building_part.building_id, points[0].id, points[4].id) }

    let(:result) do
      [{ point_id: points[0].id, weight: 1, point: { building_part_id: building_part.id,
                                                     id: points[0].id, description: nil,
                                                     name: points[0].name,
                                                     point_type: 'crossroads',
                                                     x_value: points[0].x_value, y_value: points[0].y_value } },
       { point_id: points[1].id, weight: 2, point: { building_part_id: building_part.id,
                                                     id: points[1].id, description: nil,
                                                     name: points[1].name,
                                                     point_type: 'crossroads',
                                                     x_value: points[1].x_value, y_value: points[1].y_value } },
       { point_id: points[2].id, weight: 3, point: { building_part_id: building_part.id,
                                                     id: points[2].id, description: nil,
                                                     name: points[2].name,
                                                     point_type: 'crossroads',
                                                     x_value: points[2].x_value, y_value: points[2].y_value } },
       { point_id: points[3].id, weight: 4, point: { building_part_id: building_part.id,
                                                     id: points[3].id, description: nil,
                                                     name: points[3].name,
                                                     point_type: 'crossroads',
                                                     x_value: points[3].x_value, y_value: points[3].y_value } },
       { point_id: points[4].id, weight: 0, point: { building_part_id: building_part.id,
                                                     id: points[4].id, description: nil,
                                                     name: points[4].name,
                                                     point_type: 'crossroads',
                                                     x_value: points[4].x_value, y_value: points[4].y_value } }]
    end

    before :each do
      allow_any_instance_of(described_class).to receive(:aggregate_steps).and_wrap_original do |_original_method, *args, &_block|
        args[0]
      end
    end

    it { expect(subject.find.path.map { |item| item[:weight] }).to eq(result.map { |item| item[:weight] }) }
    it { expect(subject.find.path.map { |item| item[:point_id] }).to eq(result.map { |item| item[:point_id] }) }
    it { expect(subject.find.path[0][:point][:x_value]).to eq(result[0][:point][:x_value]) }
    it { expect(subject.find.path[1][:point][:x_value]).to eq(result[1][:point][:x_value]) }
  end
end
