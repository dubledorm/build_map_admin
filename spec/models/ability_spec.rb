# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Ability do
  subject(:ability) { Ability.new(admin_user) }
  let(:admin_user) { nil }

  describe AdminUser do

    context 'when user is not authorise' do
      it { expect(ability).to_not be_able_to(:manage, admin_user) }
    end

    context 'when user is a system_admin' do
      let(:admin_user) { FactoryBot.create :system_admin }
      let(:user_without_role) { FactoryBot.create :admin_user }
      let(:user_without_role_same_organization) { FactoryBot.create :admin_user, organization: admin_user.organization }

      it { expect(ability).to_not be_able_to(:manage, user_without_role) }
      it { expect(ability).to_not be_able_to(:manage, user_without_role_same_organization) }
      it { expect(ability).to be_able_to(:read, user_without_role) }
      it { expect(ability).to be_able_to(:read, user_without_role_same_organization) }
    end

    context 'when user is a account manager' do
      let(:admin_user) { FactoryBot.create :system_account_manager }
      let(:user_without_role) { FactoryBot.create :admin_user }
      let(:user_without_role_same_organization) { FactoryBot.create :admin_user, organization: admin_user.organization }

      it { expect(ability).to_not be_able_to(:manage, user_without_role) }
      it { expect(ability).to be_able_to(:manage, user_without_role_same_organization) }
      it { expect(ability).to_not be_able_to(:read, user_without_role) }
      it { expect(ability).to be_able_to(:read, user_without_role_same_organization) }
      it { expect(ability).to_not be_able_to(:destroy, admin_user) }
    end

    context 'when user is a system_manager' do
      let(:admin_user) { FactoryBot.create :system_manager }
      let(:user_without_role) { FactoryBot.create :admin_user }
      let(:user_without_role_same_organization) { FactoryBot.create :admin_user, organization: admin_user.organization }

      it { expect(ability).to_not be_able_to(:manage, user_without_role) }
      it { expect(ability).to_not be_able_to(:manage, user_without_role_same_organization) }
      it { expect(ability).to be_able_to(:read, user_without_role) }
      it { expect(ability).to be_able_to(:read, user_without_role_same_organization) }
    end

    context 'when user is a client_user' do
      let(:admin_user) { FactoryBot.create :client_user }
      let(:user_without_role) { FactoryBot.create :admin_user }
      let(:user_without_role_same_organization) { FactoryBot.create :admin_user, organization: admin_user.organization }

      it { expect(ability).to_not be_able_to(:manage, user_without_role) }
      it { expect(ability).to_not be_able_to(:manage, user_without_role_same_organization) }
      it { expect(ability).to_not be_able_to(:read, user_without_role) }
      it { expect(ability).to_not be_able_to(:read, user_without_role_same_organization) }
    end

    context 'when user is a client_owner' do
      let(:admin_user) { FactoryBot.create :client_owner }
      let(:user_without_role) { FactoryBot.create :admin_user }
      let(:user_without_role_same_organization) { FactoryBot.create :admin_user, organization: admin_user.organization }
      let(:self_building) { FactoryBot.create :building, organization: admin_user.organization }
      let(:self_building_part) { FactoryBot.create :building_part, organization: admin_user.organization, building: self_building }
      let(:alien_building) { FactoryBot.create :building }
      let(:alien_building_part) { FactoryBot.create :building_part, organization: alien_building.organization, building: alien_building }

      it { expect(ability).to_not be_able_to(:manage, user_without_role) }
      it { expect(ability).to be_able_to(:manage, user_without_role_same_organization) }
      it { expect(ability).to_not be_able_to(:read, user_without_role) }
      it { expect(ability).to be_able_to(:read, user_without_role_same_organization) }
      it { expect(ability).to_not be_able_to(:destroy, admin_user) }

      it { expect(ability).to be_able_to(:manage, self_building) }
      it { expect(ability).to_not be_able_to(:read, alien_building) }
      it { expect(ability).to be_able_to(:manage, self_building_part) }
      it { expect(ability).to_not be_able_to(:read, alien_building_part) }
    end
  end

  describe Role do
    context 'when user is not authorise' do
      it { expect(ability).to_not be_able_to(:manage, Role.new) }
    end

    context 'when user is a system_admin' do
      let(:admin_user) { FactoryBot.create :system_admin }
      let(:user_another_organization) { FactoryBot.create :client_user }
      let(:user_the_same_organization) { FactoryBot.create :client_user, organization: admin_user.organization }

      it { expect(ability).to_not be_able_to(:manage, user_another_organization.roles.first) }
      it { expect(ability).to_not be_able_to(:manage, user_the_same_organization.roles.first) }
      it { expect(ability).to be_able_to(:read, user_another_organization.roles.first) }
      it { expect(ability).to be_able_to(:read, user_the_same_organization.roles.first) }
    end

    context 'when user is a account manager' do
      let(:admin_user) { FactoryBot.create :system_account_manager }
      let(:user_another_organization) { FactoryBot.create :client_user }
      let(:user_the_same_organization) { FactoryBot.create :client_user, organization: admin_user.organization }

      it { expect(ability).to_not be_able_to(:manage, user_another_organization.roles.first) }
      it { expect(ability).to be_able_to(:manage, user_the_same_organization.roles.first) }
      it { expect(ability).to_not be_able_to(:read, user_another_organization.roles.first) }
      it { expect(ability).to be_able_to(:read, user_the_same_organization.roles.first) }
    end

    context 'when user is a system_manager' do
      let(:admin_user) { FactoryBot.create :system_manager }
      let(:user_another_organization) { FactoryBot.create :client_user }
      let(:user_the_same_organization) { FactoryBot.create :client_user, organization: admin_user.organization }

      it { expect(ability).to_not be_able_to(:manage, user_another_organization.roles.first) }
      it { expect(ability).to_not be_able_to(:manage, user_the_same_organization.roles.first) }
      it { expect(ability).to be_able_to(:read, user_another_organization.roles.first) }
      it { expect(ability).to be_able_to(:read, user_the_same_organization.roles.first) }
    end

    context 'when user is a client_user' do
      let(:admin_user) { FactoryBot.create :client_user }
      let(:user_another_organization) { FactoryBot.create :client_user }
      let(:user_the_same_organization) { FactoryBot.create :client_user, organization: admin_user.organization }

      it { expect(ability).to_not be_able_to(:manage, user_another_organization.roles.first) }
      it { expect(ability).to_not be_able_to(:manage, user_the_same_organization.roles.first) }
      it { expect(ability).to_not be_able_to(:read, user_another_organization.roles.first) }
      it { expect(ability).to_not be_able_to(:read, user_the_same_organization.roles.first) }
    end

    context 'when user is a client_owner' do
      let(:admin_user) { FactoryBot.create :client_owner }
      let(:user_another_organization) { FactoryBot.create :client_user }
      let(:user_the_same_organization) { FactoryBot.create :client_user, organization: admin_user.organization }

      it { expect(ability).to_not be_able_to(:manage, user_another_organization.roles.first) }
      it { expect(ability).to be_able_to(:manage, user_the_same_organization.roles.first) }
      it { expect(ability).to_not be_able_to(:read, user_another_organization.roles.first) }
      it { expect(ability).to be_able_to(:read, user_the_same_organization.roles.first) }
    end
  end
end
