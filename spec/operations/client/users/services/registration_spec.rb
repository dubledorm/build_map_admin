# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Client::Users::Services::Registration do
  context 'when data is right' do
    let(:subject) do
      described_class.client_owner('some_name',
                                   'k@k.ru',
                                   '12345678',
                                   '12345678')
    end

    it { expect(subject.is_a?(Client::Users::Dto::RegistrationResponse)).to be_truthy }
    it { expect(subject.success?).to be_truthy }
    it { expect(subject.user.is_a?(AdminUser)).to be_truthy }
    it { expect { subject }.to change(AdminUser, :count).by(1) }
    it { expect { subject }.to change(Organization, :count).by(1) }
  end

  context 'when data is wrong' do
    let(:subject) do
      described_class.client_owner('some_name',
                                   'k@k.ru',
                                   '12345678',
                                   'another')
    end

    it { expect(subject.is_a?(Client::Users::Dto::RegistrationResponse)).to be_truthy }
    it { expect(subject.success?).to be_falsey }
    it { expect(subject.message).to eq(I18n.t('operations.client.users.services.registration.bad_admin_user')) }
    it { expect(subject.user.is_a?(AdminUser)).to be_truthy }
    it { expect { subject }.to change(AdminUser, :count).by(0) }
    it { expect { subject }.to change(Organization, :count).by(0) }
  end
end
