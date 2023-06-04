# frozen_string_literal: true

require 'rails_helper'
require 'rule_list/rule_list_item'

RSpec.describe Client::Users::Services::ValidateUpdate do
  describe 'deleted role' do
    let(:params_admin_user) do
      { 'email' => 'client1@mail.ru',
        'roles_attributes' => { '0' => { 'name' => 'client_user',
                                         '_destroy' => '0',
                                         'id' => '16' },
                                '1' => { 'name' => 'client_owner',
                                         '_destroy' => '1',
                                         'id' => '19' } } }
    end

    context 'when one client and he is single client_owner' do
      let(:client) { FactoryBot.create :client_owner_client_user, email: 'client1@mail.ru' }

      let(:subject) do
        described_class.new(params_admin_user, client, client)
      end

      it { expect(subject.valid?).to be_falsey }

      it 'should fills array of errors' do
        validator = subject
        validator.valid?
        expect(validator.errors.count).to eq(1)
        expect(validator.errors).to eq([{ messages: [I18n.t('operations.client.users.services.validate_update.CouldNotDeleteLastClientOwner'),
                                                     I18n.t('operations.client.users.services.validate_update.CouldNotDeleteSelfClientOwner')],
                                          role: { current_user_id: client.id,
                                                  organization_id: client.organization_id,
                                                  role_id: '19',
                                                  role_name: 'client_owner',
                                                  user_id: client.id } }])
      end
    end

    context 'when exists another client_owner' do
      let!(:organization) { FactoryBot.create :organization }
      let!(:client_user) { FactoryBot.create :client_user, organization:, email: 'client_user@mail.ru' }
      let!(:client_owner) { FactoryBot.create :client_owner, organization:, email: 'client_owner@mail.ru' }
      let!(:client_owner1) { FactoryBot.create :client_owner, organization:, email: 'client_owner1@mail.ru' }

      let(:subject) do
        described_class.new(params_admin_user, client_user, client_owner)
      end

      it { expect(AdminUser.count).to eq(3) }
      it { expect(Organization.count).to eq(1) }

      it { expect(subject.valid?).to be_truthy }

      it 'should fills array of errors' do
        validator = subject
        validator.valid?
        expect(validator.errors).to eq([])
      end
    end
  end
end
