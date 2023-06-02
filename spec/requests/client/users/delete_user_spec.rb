# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'DeleteUser', type: :request do
  context 'when user dose not signed in' do
    let!(:organization) { FactoryBot.create :organization }
    let!(:client_owner) { FactoryBot.create :client_owner, organization: organization }
    let!(:another_user) { FactoryBot.create :client_user, organization: organization, email: 'new@email.ru' }
    let(:subject) do
      delete admin_admin_user_path(id: another_user.id)
    end

    it 'should redirect to login' do
      subject
      expect(response).to redirect_to(new_admin_user_session_path)
    end

    it { expect { subject }.to change(AdminUser, :count).by(0) }
  end

  context 'when user signed in and data is right' do
    let!(:organization) { FactoryBot.create :organization }
    let!(:client_owner) { FactoryBot.create :client_owner, organization: organization }
    let!(:another_user) { FactoryBot.create :client_user, organization: organization, email: 'new@email.ru' }
    let(:subject) do
      delete admin_admin_user_path(id: another_user.id)
    end

    before :each do
      post admin_user_session_path, params: { admin_user: { email: client_owner.email,
                                                            password: client_owner.password } }
    end

    it 'should return redirect status' do
      subject
      expect(response).to have_http_status(302)
    end

    it { expect { subject }.to change(AdminUser, :count).by(-1) }
    it { expect { subject }.to change(Organization, :count).by(0) }

    it 'should redirect to users' do
      subject
      expect(response).to redirect_to(admin_admin_users_path)
    end
  end

  context 'when delete self' do
    let!(:organization) { FactoryBot.create :organization }
    let!(:client_owner) { FactoryBot.create :client_owner, organization: organization }
    let!(:another_user) { FactoryBot.create :client_user, organization: organization, email: 'new@email.ru' }
    let(:subject) do
      delete admin_admin_user_path(id: client_owner.id)
    end

    before :each do
      post admin_user_session_path, params: { admin_user: { email: client_owner.email,
                                                            password: client_owner.password } }
    end

    it 'should redirect to' do
      subject
      expect(response).to have_http_status(302)
      expect(response).to redirect_to(root_path)
    end

    it { expect { subject }.to change(AdminUser, :count).by(0) }
    it { expect { subject }.to change(Organization, :count).by(0) }
  end
end
