# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Core::Routes::Services::VerticalPathSpeaker do
  describe 'direction' do
    let(:building_part1) { FactoryBot.create :building_part, level: 1 }
    let(:building_part2) { FactoryBot.create :building_part, level: 2 }
    let!(:examples) do
      [{ building_part1:, building_part2:, result: :walk_up },
       { building_part1: building_part2, building_part2: building_part1, result: :walk_down },
       { building_part1: building_part2, building_part2:, result: :walk_down }]
    end

    it do
      examples.each do |example|
        point1 = FactoryBot.create :point, building_part: example[:building_part1]
        point2 = FactoryBot.create :point, building_part: example[:building_part2]
        point1_hash = point1.as_json(except: Core::Routes::Services::FindPath::EXCEPT_FIELDS).symbolize_keys
        point2_hash = point2.as_json(except: Core::Routes::Services::FindPath::EXCEPT_FIELDS).symbolize_keys

        p "Этаж 1 = #{example[:building_part1].level} Этаж 2 = #{example[:building_part2].level} "
        expect(described_class.new(point1_hash, point2_hash, { weight: 10 }, nil, 10)
                              .user_direction).to eq(example[:result])
      end
    end
  end

  describe 'direction error' do
    let(:building_part1) { FactoryBot.create :building_part, level: 1 }
    let(:building_part2) { FactoryBot.create :building_part, level: 2 }
    let(:point1) { FactoryBot.create :point, building_part: building_part1 }
    let(:point2) { FactoryBot.create :point, building_part: building_part2 }
    let(:point1_hash) { point1.as_json(except: Core::Routes::Services::FindPath::EXCEPT_FIELDS).symbolize_keys }
    let(:point2_hash) { point2.as_json(except: Core::Routes::Services::FindPath::EXCEPT_FIELDS).symbolize_keys }

    it 'should return BaseSpeakerError when exit_map_direction did not set in road hash' do
      expect do
        described_class.new(point1_hash, point2_hash, { weight: 10 }, nil, 10)
                       .map_direction
      end.to raise_error(Core::Routes::Services::BaseSpeakerError)
    end
  end
end
