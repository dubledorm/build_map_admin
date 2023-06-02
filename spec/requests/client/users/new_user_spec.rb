# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'NewUser', type: :request do
  context 'when user dose not signed in' do
    let(:subject) do
      post admin_admin_users_path, params: { admin_user: { email: 'new@email.ru' } }
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
    let(:subject) do
      post admin_admin_users_path, params: { admin_user: { email: 'new@email.ru' } }
    end
    let(:created_user) { AdminUser.where(email: 'new@email.ru').first }

    before :each do
      post admin_user_session_path, params: { admin_user: { email: client_owner.email,
                                                            password: client_owner.password } }
    end

    it 'should return redirect status' do
      subject
      expect(response).to have_http_status(302)
    end

    it { expect { subject }.to change(AdminUser, :count).by(1) }
    it { expect { subject }.to change(Organization, :count).by(0) }

    it 'should associate user with organization' do
      subject
      expect(created_user.organization).to eq(organization)
    end

    it 'should assigns :client_user role' do
      subject
      expect(created_user.role?(:client_user)).to be_truthy
    end

    it 'should redirect to new user' do
      subject
      expect(response).to redirect_to(admin_admin_user_path(id: created_user.id))
    end
  end

  context 'when data is wrong' do
    let!(:organization) { FactoryBot.create :organization }
    let!(:client_owner) { FactoryBot.create :client_owner, organization: organization }
    let!(:another_user) { FactoryBot.create :client_user, organization: organization, email: 'new@email.ru' }
    let(:subject) do
      post admin_admin_users_path, params: { admin_user: { email: 'new@email.ru' } }
    end

    before :each do
      post admin_user_session_path, params: { admin_user: { email: client_owner.email,
                                                            password: client_owner.password } }
    end

    it 'should render new user' do
      subject
      expect(response).to render_template(:new)
    end

    it { expect { subject }.to change(AdminUser, :count).by(0) }
    it { expect { subject }.to change(Organization, :count).by(0) }
  end
end
