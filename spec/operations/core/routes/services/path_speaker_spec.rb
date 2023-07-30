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

        expect(described_class.new(point1_hash, point2_hash, 10, example[:current_direction])
                              .user_direction).to eq(example[:result])
      end
    end
  end

  describe 'length_m' do
    let(:point1) { FactoryBot.create :point, x_value: 0, y_value: 100 }
    let(:point2) { FactoryBot.create :point, x_value: 100, y_value: 200 }
    let(:point1_hash) { point1.as_json(except: Core::Routes::Services::FindPath::EXCEPT_FIELDS).symbolize_keys }
    let(:point2_hash) { point2.as_json(except: Core::Routes::Services::FindPath::EXCEPT_FIELDS).symbolize_keys }

    it { expect(described_class.new(point1_hash, point2_hash, 100, :up).length_m).to eq(10) }
  end

  describe 'legend' do
    let(:point1) { FactoryBot.create :point, x_value: 0, y_value: 100 }
    let(:point2) { FactoryBot.create :point, x_value: 100, y_value: 200 }
    let(:point1_hash) { point1.as_json(except: Core::Routes::Services::FindPath::EXCEPT_FIELDS).symbolize_keys }
    let(:point2_hash) { point2.as_json(except: Core::Routes::Services::FindPath::EXCEPT_FIELDS).symbolize_keys }

    it do
      expect(described_class.new(point1_hash, point2_hash,
                                 100, :up).legend).to eq('Поверните на право и пройдите 10 метров')

    end
  end

  describe 'finish' do
    let(:point1) { FactoryBot.create :point, x_value: 0, y_value: 100 }
    let(:point1_hash) { point1.as_json(except: Core::Routes::Services::FindPath::EXCEPT_FIELDS).symbolize_keys }

    it do
      expect(described_class.new(point1_hash, nil,
                                 100, :up).legend).to eq('Вы пришли')

    end
  end
end
