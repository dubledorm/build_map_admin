# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Core::Routes::Services::PathSpeaker do
  describe 'direction' do
    let!(:examples) do
      [{ x1: 0, y1: 0, x2: 0, y2: 100, current_direction: :up, result: :backward },
       { x1: 0, y1: 100, x2: 0, y2: 0, current_direction: :up, result: :forward },
       { x1: 0, y1: 0, x2: 100, y2: 0, current_direction: :up, result: :right },
       { x1: 100, y1: 0, x2: 0, y2: 0, current_direction: :up, result: :left },
       { x1: 0, y1: 0, x2: 10, y2: 100, current_direction: :up, result: :backward },
       { x1: 0, y1: 0, x2: 99, y2: 100, current_direction: :up, result: :backward },
       { x1: 0, y1: 0, x2: 100, y2: 100, current_direction: :up, result: :right },
       { x1: 100, y1: 100, x2: 90, y2: 0, current_direction: :up, result: :forward },
       { x1: 100, y1: 100, x2: 1, y2: 0, current_direction: :up, result: :forward },
       { x1: 100, y1: 100, x2: 0, y2: 0, current_direction: :up, result: :left },
       { x1: 0, y1: 0, x2: 0, y2: 100, current_direction: :right, result: :right },
       { x1: 0, y1: 100, x2: 0, y2: 0, current_direction: :right, result: :left },
       { x1: 0, y1: 0, x2: 100, y2: 0, current_direction: :right, result: :forward },
       { x1: 100, y1: 0, x2: 0, y2: 0, current_direction: :right, result: :backward },
       { x1: 0, y1: 0, x2: 0, y2: 100, current_direction: :left, result: :left },
       { x1: 0, y1: 100, x2: 0, y2: 0, current_direction: :left, result: :right },
       { x1: 0, y1: 0, x2: 100, y2: 0, current_direction: :left, result: :backward },
       { x1: 100, y1: 0, x2: 0, y2: 0, current_direction: :left, result: :forward }]
    end

    it do
      examples.each do |example|
        point1 = FactoryBot.create :point, x_value: example[:x1], y_value: example[:y1]
        point2 = FactoryBot.create :point, x_value: example[:x2], y_value: example[:y2]
        point1_hash = point1.as_json(except: Core::Routes::Services::FindPath::EXCEPT_FIELDS).symbolize_keys
        point2_hash = point2.as_json(except: Core::Routes::Services::FindPath::EXCEPT_FIELDS).symbolize_keys

        expect(described_class.new(point1_hash, point2_hash, { weight: 10 }, example[:current_direction], 10)
                              .user_direction).to eq(example[:result])
      end
    end
  end

  describe 'length_m' do
    let(:point1) { FactoryBot.create :point, x_value: 0, y_value: 100 }
    let(:point2) { FactoryBot.create :point, x_value: 100, y_value: 200 }
    let(:point1_hash) { point1.as_json(except: Core::Routes::Services::FindPath::EXCEPT_FIELDS).symbolize_keys }
    let(:point2_hash) { point2.as_json(except: Core::Routes::Services::FindPath::EXCEPT_FIELDS).symbolize_keys }

    it { expect(described_class.new(point1_hash, point2_hash, { weight: 100000 }, :up, 10).length_m).to eq(10) }
  end

  describe 'legend' do
    let(:point1) { FactoryBot.create :point, x_value: 0, y_value: 100 }
    let(:point2) { FactoryBot.create :point, x_value: 100, y_value: 200 }
    let(:point1_hash) { point1.as_json(except: Core::Routes::Services::FindPath::EXCEPT_FIELDS).symbolize_keys }
    let(:point2_hash) { point2.as_json(except: Core::Routes::Services::FindPath::EXCEPT_FIELDS).symbolize_keys }

    it do
      expect(described_class.new(point1_hash, point2_hash,
                                 { weight: 100000 }, :up, 10).legend).to eq('Поверните направо и пройдите 10 метров')
      expect(described_class.new(point1_hash, point2_hash,
                                 { weight: 100000 }, :up, 100).legend).to eq('Поверните направо и пройдите 1 метров')
    end
  end

  describe 'finish' do
    let(:point1) { FactoryBot.create :point, x_value: 0, y_value: 100 }
    let(:point1_hash) { point1.as_json(except: Core::Routes::Services::FindPath::EXCEPT_FIELDS).symbolize_keys }

    it do
      expect(described_class.new(point1_hash, nil,
                                 { weight: 100 }, :up, 10).legend).to eq('Вы пришли')

    end
  end

  describe 'error parameters' do
    let(:building_part1) { FactoryBot.create :building_part, level: 1 }
    let(:point1) { FactoryBot.create :point, building_part: building_part1, x_value: 0, y_value: 100 }
    let(:point2) { FactoryBot.create :point, building_part: building_part1, x_value: 0, y_value: 0 }
    let(:point1_hash) { point1.as_json(except: Core::Routes::Services::FindPath::EXCEPT_FIELDS).symbolize_keys }
    let(:point2_hash) { point2.as_json(except: Core::Routes::Services::FindPath::EXCEPT_FIELDS).symbolize_keys }

    it 'should return BaseSpeakerError when current_direction did not set' do
      expect do
        described_class.new(point1_hash, point2_hash, { weight: 10 }, nil, 10)
                       .user_direction
      end.to raise_error(Core::Routes::Services::BaseSpeakerError)
    end
  end

  describe 'build_without_map_scale' do
    let(:point1_hash) { { id: 284, building_part_id: 7, point_type: 'crossroads', name: nil, description: nil, x_value: 349070, y_value: 88850, label_direction: 'none' } }
    let(:point2_hash) { { id: 301, building_part_id: 7, point_type: 'crossroads', name: nil, description: nil, x_value: 386070, y_value: 88850, label_direction: 'none'} }
    let(:weight) { 3 }
    let(:current_direction) { :right }

    it do
      expect(described_class.build_without_map_scale(point1_hash, point2_hash, weight, current_direction).legend).to eq('Двигайтесь прямо 3 метров')
    end
  end
end
