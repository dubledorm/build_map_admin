require 'rails_helper'

RSpec.describe AdminUser, type: :model do
  describe 'factory' do
    let!(:admin_user) { FactoryBot.create :admin_user }
    let!(:system_admin_user) { FactoryBot.create :system_admin }
    let!(:system_account_manager) { FactoryBot.create :system_account_manager }
    let!(:client_user) { FactoryBot.create :client_user }
    let!(:client_owner) { FactoryBot.create :client_owner }
    let!(:system_manager) { FactoryBot.create :system_manager }

    # Factories
    it { expect(admin_user).to be_valid }

    it { should belong_to(:organization) }
    it { should have_many(:roles) }

    it { expect(system_admin_user).to be_valid }
    it { expect(system_admin_user.role?('system_admin')).to be_truthy }
    it { expect(system_admin_user.role?('client_user')).to be_falsey }

    it { expect(system_account_manager).to be_valid }
    it { expect(system_account_manager.role?('system_account_manager')).to be_truthy }
    it { expect(system_account_manager.role?('client_user')).to be_falsey }

    it { expect(client_user).to be_valid }
    it { expect(client_user.role?('client_user')).to be_truthy }
    it { expect(client_user.role?('system_admin')).to be_falsey }

    it { expect(client_owner).to be_valid }
    it { expect(client_owner.role?('client_owner')).to be_truthy }
    it { expect(client_owner.role?('client_user')).to be_falsey }

    it { expect(system_manager).to be_valid }
    it { expect(system_manager.role?('system_manager')).to be_truthy }
    it { expect(system_manager.role?('client_user')).to be_falsey }
  end
end
