# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Road, type: :model do
  describe 'factory' do
    let!(:road) { FactoryBot.create :road }

    # Factories
    it { expect(road).to be_valid }

    # Validations
    it { should validate_presence_of(:weight) }

    it { should belong_to(:organization) }
    it { should belong_to(:building_part) }
    it { should belong_to(:point1) }
    it { should belong_to(:point2) }
  end
end
