# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Group, type: :model do
  describe 'factory' do
    let!(:group) { FactoryBot.create :group }

    # Factories
    it { expect(group).to be_valid }

    # Validations
    it { should validate_presence_of(:name) }

    it { should belong_to(:building) }
  end
end
