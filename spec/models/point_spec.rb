# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Point, type: :model do
  describe 'factory' do
    let!(:point) { FactoryBot.create :point }

    # Factories
    it { expect(point).to be_valid }

    # Validations
    it { should validate_presence_of(:x_value) }
    it { should validate_presence_of(:y_value) }
    it { should validate_presence_of(:point_type) }

    it { should belong_to(:organization) }
    it { should belong_to(:building_part) }
    it { should have_one(:point1_roads) }
    it { should have_one(:point2_roads) }
  end

  describe 'validations' do
    it { expect(FactoryBot.build(:point, point_type: 'target')).to be_valid }
    it { expect(FactoryBot.build(:point, point_type: 'crossroads')).to be_valid }
    it { expect(FactoryBot.build(:point, point_type: 'another')).to_not be_valid }
  end

  describe 'by_name scope' do
    let!(:point1) { FactoryBot.create :point, name: 'первая точка' }
    let!(:point2) { FactoryBot.create :point, name: 'вторая точка' }

    it { expect(described_class.by_name('первая').count).to eq(1) }
    it { expect(described_class.by_name('точка').count).to eq(2) }
  end
end
