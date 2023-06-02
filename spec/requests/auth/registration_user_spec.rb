# frozen_string_literal: true

require 'rails_helper'
#require 'support/devise_support'


RSpec.describe 'RegistrationUser', type: :request do
  context 'when data is right' do
    let(:subject) do
      post admin_user_registration_path, params: { admin_user: { email: 'new@email.ru',
                                                                 password: 'password',
                                                                 password_confirmation: 'password' } }
    end

    it 'should return redirect status' do
      subject
      expect(response).to have_http_status(302)
    end

    it { expect { subject }.to change(AdminUser, :count).by(1) }
    it { expect { subject }.to change(Organization, :count).by(1) }

    it 'should associate user with organization' do
      subject
      expect(AdminUser.first.organization).to eq(Organization.first)
    end

    it 'should assigns :client_owner role' do
      subject
      expect(AdminUser.first.role?(:client_owner)).to be_truthy
    end

    it 'should redirect to new user' do
      subject
      expect(response).to redirect_to(admin_admin_user_path(id: AdminUser.first.id))
    end
  end

  context 'when data is wrong' do
    let(:subject) do
      post admin_user_registration_path, params: { admin_user: { email: 'new@email.ru',
                                                                 password: 'password',
                                                                 password_confirmation: 'another_password' } }
    end

    it 'should render new user' do
      subject
      expect(response).to render_template(:new)
    end

    it { expect { subject }.to change(AdminUser, :count).by(0) }
    it { expect { subject }.to change(Organization, :count).by(0) }
  end
end
