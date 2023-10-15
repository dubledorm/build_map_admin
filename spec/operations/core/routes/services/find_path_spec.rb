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
      allow_any_instance_of(Point).to receive(:label_direction).and_return('up')
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
      allow_any_instance_of(Point).to receive(:label_direction).and_return('up')
      subject.send(:init)
    end

    context 'when first element order is true' do
      let!(:roads_fiber_result) do
        [{ id: 1, point1_id: 1, point2_id: 2, weight: 1, road_type: 'road' },
         { id: 2, point1_id: 3, point2_id: 2, weight: 2, road_type: 'road' },
         { id: 3, point1_id: 3, point2_id: 4, weight: 3, road_type: 'road' },
         { id: 4, point1_id: 5, point2_id: 4, weight: 4, road_type: 'road' },
         nil]
      end

      it do
        point_and_weight_array = subject.send(:build_point_and_weight_array, roads_fiber)
        expect(point_and_weight_array).to eq([{ point_id: 1, weight: 1, road: { id: 1, point1_id: 1, point2_id: 2, weight: 1, road_type: 'road' } },
                                              { point_id: 2, weight: 2, road: { id: 2, point1_id: 3, point2_id: 2, weight: 2, road_type: 'road' } },
                                              { point_id: 3, weight: 3, road: { id: 3, point1_id: 3, point2_id: 4, weight: 3, road_type: 'road' } },
                                              { point_id: 4, weight: 4, road: { id: 4, point1_id: 5, point2_id: 4, weight: 4, road_type: 'road' } },
                                              { point_id: 5, weight: 0, road: nil }])
      end
    end

    context 'when first element order is false' do
      let!(:roads_fiber_result) do
        [{ id: 1, point1_id: 2, point2_id: 1, weight: 1, road_type: 'road' },
         { id: 2, point1_id: 3, point2_id: 2, weight: 2, road_type: 'road' },
         { id: 3, point1_id: 3, point2_id: 4, weight: 3, road_type: 'road'},
         { id: 4, point1_id: 5, point2_id: 4, weight: 4, road_type: 'road' },
         nil]
      end

      it do
        point_and_weight_array = subject.send(:build_point_and_weight_array, roads_fiber)
        expect(point_and_weight_array).to eq([{ point_id: 1, weight: 1, road: { id: 1, point1_id: 2, point2_id: 1, weight: 1, road_type: 'road' } },
                                              { point_id: 2, weight: 2, road: { id: 2, point1_id: 3, point2_id: 2, weight: 2, road_type: 'road' } },
                                              { point_id: 3, weight: 3, road: { id: 3, point1_id: 3, point2_id: 4, weight: 3, road_type: 'road' } },
                                              { point_id: 4, weight: 4, road: { id: 4, point1_id: 5, point2_id: 4, weight: 4, road_type: 'road' } },
                                              { point_id: 5, weight: 0, road: nil }])
      end
    end
  end

  describe 'find' do
    let!(:points) { FactoryBot.create_list :point, 10, building_part:, label_direction: 'up'}
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
       { point_id: points[4].id, weight: nil, point: { building_part_id: building_part.id,
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

  describe 'wrong cases' do
    context 'when roads dose not exists' do
      let!(:building) { FactoryBot.create :building }
      let!(:floor1) { FactoryBot.create :building_part, building: }
      let!(:floor2) { FactoryBot.create :building_part, building: }
      let!(:point1) { FactoryBot.create :point, building_part: floor1, label_direction: 'up' }
      let!(:point2) { FactoryBot.create :point, building_part: floor2 }
      let(:subject) { described_class.new(building.id, point1.id, point2.id) }

      it { expect(subject.find.is_a?(Core::Routes::Dto::FindPathResponse)).to be_truthy }
      it { expect(subject.find.success?).to be_falsey }
      it { expect(subject.find.message).to eq("Точка с id - #{point1.id} не принадлежит ни одной дуге") }
    end

    context 'when path dose not exists' do
      let!(:building) { FactoryBot.create :building }
      let!(:floor1) { FactoryBot.create :building_part, building: }
      let!(:floor2) { FactoryBot.create :building_part, building: }
      let!(:point1) { FactoryBot.create :point, building_part: floor1, label_direction: 'up' }
      let!(:point2) { FactoryBot.create :point, building_part: floor1 }
      let!(:point3) { FactoryBot.create :point, building_part: floor2 }
      let!(:point4) { FactoryBot.create :point, building_part: floor2 }
      let!(:road1) { FactoryBot.create :road, point1:, point2:, building_part: floor1 }
      let!(:road2) { FactoryBot.create :road, point1: point3, point2: point4, building_part: floor2 }
      let(:subject) { described_class.new(building.id, point1.id, point3.id) }

      it { expect(subject.find.is_a?(Core::Routes::Dto::FindPathResponse)).to be_truthy }
      it { expect(subject.find.success?).to be_falsey }
      it { expect(subject.find.message).to eq("Не могу найти маршрут от точки #{point1.id} до точки #{point3.id}") }
    end
  end

  describe 'label_direction' do
    let!(:building) { FactoryBot.create :building }
    let!(:floor1) { FactoryBot.create :building_part, building:, map_scale: 10 }
    let!(:point1) { FactoryBot.create :point, building_part: floor1, x_value: 1000, y_value: 1000 }
    let!(:point2) { FactoryBot.create :point, building_part: floor1, x_value: 2000, y_value: 1000 }
    let!(:point3) { FactoryBot.create :point, building_part: floor1, x_value: 2000, y_value: 3000 }
    let!(:road1) { FactoryBot.create :road, point1:, point2:, building_part: floor1, weight: 1000 }
    let!(:road2) { FactoryBot.create :road, point1: point2, point2: point3, building_part: floor1, weight: 1000 }

    let(:subject) { described_class.new(building.id, point1.id, point3.id) }

    context 'when start point label direction is up' do
      before :each do
        point1.update(label_direction: 'up')
      end

      it { expect(subject.find.is_a?(Core::Routes::Dto::FindPathResponse)).to be_truthy }
      it { expect(subject.find.success?).to be_truthy }
      it { expect(subject.find.path.map { |point| point[:direction] }).to eq(%i[right right finish]) }
      it { expect(subject.find.path.map { |point| point[:map_direction] }).to eq(%i[right down finish]) }
    end

    context 'when start point label direction is down' do
      before :each do
        point1.update(label_direction: 'down')
      end

      it { expect(subject.find.is_a?(Core::Routes::Dto::FindPathResponse)).to be_truthy }
      it { expect(subject.find.success?).to be_truthy }
      it { expect(subject.find.path.map { |point| point[:direction] }).to eq(%i[left right finish]) }
      it { expect(subject.find.path.map { |point| point[:map_direction] }).to eq(%i[right down finish]) }
    end

    context 'when start point label direction is left' do
      before :each do
        point1.update(label_direction: 'left')
      end

      it { expect(subject.find.is_a?(Core::Routes::Dto::FindPathResponse)).to be_truthy }
      it { expect(subject.find.success?).to be_truthy }
      it { expect(subject.find.path.map { |point| point[:direction] }).to eq(%i[backward right finish]) }
      it { expect(subject.find.path.map { |point| point[:map_direction] }).to eq(%i[right down finish]) }
    end
  end

  describe 'road staircase' do
    let!(:building) { FactoryBot.create :building }
    let!(:floor1) { FactoryBot.create :building_part, building:, map_scale: 10, level: 1 }
    let!(:floor2) { FactoryBot.create :building_part, building:, map_scale: 10, level: 2 }
    let!(:point1) { FactoryBot.create :point, building_part: floor1, x_value: 1000, y_value: 3000, label_direction: 'up' }
    let!(:point2) { FactoryBot.create :point, building_part: floor1, x_value: 2000, y_value: 3000 }
    let!(:point3) { FactoryBot.create :point, building_part: floor1, x_value: 2000, y_value: 2900 }
    let!(:point4) { FactoryBot.create :point, building_part: floor2, x_value: 2000, y_value: 2000 }
    let!(:point5) { FactoryBot.create :point, building_part: floor2, x_value: 2000, y_value: 1000, label_direction: 'down' }
    let!(:road1) { FactoryBot.create :road, point1:, point2:, building_part: floor1, weight: 1000 }
    let!(:road2) { FactoryBot.create :road, point1: point2, point2: point3, building_part: floor1, weight: 1000 }
    let!(:road3) do
      FactoryBot.create :road, point1: point3, point2: point4, building_part: floor1, weight: 1000,
                               road_type: 'staircase', exit_map_direction1: :up, exit_map_direction2: :up
    end
    let!(:road4) { FactoryBot.create :road, point1: point4, point2: point5, building_part: floor2, weight: 1000 }

    context 'when walk up' do
      let(:subject) { described_class.new(building.id, point1.id, point5.id) }

      it { expect(subject.find.is_a?(Core::Routes::Dto::FindPathResponse)).to be_truthy }
      it { expect(subject.find.success?).to be_truthy }
      it { expect(subject.find.path.map { |point| point[:direction] }).to eq(%i[right left walk_up forward finish]) }
      it { expect(subject.find.path.map { |point| point[:map_direction] }).to eq(%i[right up up up finish]) }
    end

    context 'when walk down' do
      let(:subject) { described_class.new(building.id, point5.id, point1.id) }

      it { expect(subject.find.is_a?(Core::Routes::Dto::FindPathResponse)).to be_truthy }
      it { expect(subject.find.success?).to be_truthy }
      it { expect(subject.find.path.map { |point| point[:direction] }).to eq(%i[forward walk_down backward right finish]) }
      it { expect(subject.find.path.map { |point| point[:map_direction] }).to eq(%i[down up down left finish]) }
    end

    context 'when walk down and change direction' do
      let(:subject) { described_class.new(building.id, point5.id, point1.id) }
      before do
        road3.update(exit_map_direction1: :right)
      end

      it { expect(subject.find.is_a?(Core::Routes::Dto::FindPathResponse)).to be_truthy }
      it { expect(subject.find.success?).to be_truthy }
      it { expect(subject.find.path.map { |point| point[:direction] }).to eq(%i[forward walk_down right right finish]) }
      it { expect(subject.find.path.map { |point| point[:map_direction] }).to eq(%i[down right down left finish]) }
      it do
        expect(subject.find.path.map { |point| point[:legend] }).to eq(['Двигайтесь прямо 0 метров',
                                                                        'Спуститесь на 1 этаж',
                                                                        'Поверните направо и пройдите 0 метров',
                                                                        'Поверните направо и пройдите 0 метров',
                                                                        'Вы пришли'])
      end
    end

    context 'finish point' do
      let(:subject) { described_class.new(building.id, point1.id, point4.id) }

      it { expect(subject.find.is_a?(Core::Routes::Dto::FindPathResponse)).to be_truthy }
      it { expect(subject.find.success?).to be_truthy }
      it { expect(subject.find.path.map { |point| point[:direction] }).to eq(%i[right left walk_up finish]) }
      it { expect(subject.find.path.map { |point| point[:map_direction] }).to eq(%i[right up up finish]) }
      it do
        expect(subject.find.path.map { |point| point[:legend] }).to eq(['Поверните направо и пройдите 0 метров',
                                                                        'Поверните налево и пройдите 0 метров',
                                                                        'Поднимитесь на 2 этаж',
                                                                        'Вы пришли'])
      end
    end
  end
end
