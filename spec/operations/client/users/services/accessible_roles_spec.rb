# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Client::Users::Services::AccessibleRoles do
  context 'when user has single role' do
    let(:client_owner) { FactoryBot.create :client_owner }
    let(:client_user) { FactoryBot.create :client_user }
    let(:system_account_manager) { FactoryBot.create :system_account_manager }
    let(:system_manager) { FactoryBot.create :system_manager }
    let(:system_admin) { FactoryBot.create :system_admin }

    it { expect(described_class.roles(nil)).to eq([]) }
    it { expect(described_class.roles(client_owner)).to eq(%i[client_owner client_user]) }
    it { expect(described_class.roles(client_user)).to eq([]) }
    it { expect(described_class.roles(system_account_manager)).to eq(%i[system_manager system_admin]) }
    it { expect(described_class.roles(system_manager)).to eq([]) }
    it { expect(described_class.roles(system_admin)).to eq([]) }
  end

  context 'when user has more one roles' do
    let(:client_owner_client_user) { FactoryBot.create :client_owner_client_user }
    let(:client_owner_account_manager) { FactoryBot.create :client_owner_account_manager }

    it { expect(described_class.roles(client_owner_client_user)).to eq(%i[client_owner client_user]) }
    it { expect(described_class.roles(client_owner_account_manager)).to eq(%i[client_owner client_user system_manager system_admin]) }
  end
end
