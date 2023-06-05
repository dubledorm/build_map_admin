# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BuildingPart, type: :model do
  describe 'factory' do
    let!(:building_part) { FactoryBot.create :building_part }

    # Factories
    it { expect(building_part).to be_valid }

    # Validations
    it { should validate_presence_of(:name) }

    it { should belong_to(:organization) }
    it { should belong_to(:building) }
    it { should have_many(:points) }
    it { should have_many(:roads) }
  end

  describe 'state' do
    it { expect(FactoryBot.build :building_part, state: 'draft').to be_valid }
    it { expect(FactoryBot.build :building_part, state: 'working').to be_valid }
    it { expect(FactoryBot.build :building_part, state: 'another').to_not be_valid }
  end
end
