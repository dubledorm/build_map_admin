require 'rails_helper'

RSpec.describe Role, type: :model do
  describe 'factory' do
    let!(:role) { FactoryBot.create :role }

    # Factories
    it { expect(role).to be_valid }

    it { should belong_to(:admin_user) }
  end
end
