# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Building, type: :model do
  describe 'factory' do
    let!(:building) { FactoryBot.create :building }

    # Factories
    it { expect(building).to be_valid }

    # Validations
    it { should validate_presence_of(:name) }

    it { should have_many(:building_parts) }
    it { should belong_to(:organization) }
    it { should have_many(:points) }
    it { should have_many(:roads) }
    it { should have_many(:groups) }
  end
end
