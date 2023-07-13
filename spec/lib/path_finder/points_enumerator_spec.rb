# frozen_string_literal: true

require 'rails_helper'
require 'path_finder/points_enumerator'

RSpec.describe PointsEnumerator do
  let!(:building_part) { FactoryBot.create :building_part }
  let!(:roads) { FactoryBot.create_list :road, 10 }
  let(:subject) { described_class.new(roads) }

  it { expect(subject.count).to eq(20) }

  it do
    roads_enum = subject
    expect(roads_enum.index_by_id(roads_enum[3])).to eq(3)
  end
end
