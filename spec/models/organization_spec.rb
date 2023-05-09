# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Organization, type: :model do
  describe 'factory' do
    let!(:organization) { FactoryGirl.create :organization }

    # Factories
    it { expect(organization).to be_valid }

    # Validations
    it { should validate_presence_of(:name) }
  end
end
