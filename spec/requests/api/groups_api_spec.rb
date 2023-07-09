# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::GroupsApi, type: :request do
  include Rack::Test::Methods

  let!(:building) { FactoryBot.create :building }
  let!(:another_building) { FactoryBot.create :building }

  def app
    Api::V1::GroupsApi
  end

  context 'empty groups' do
    it 'returns an empty array of groups' do
      get "/v1/buildings/#{building.id}/groups", filter: {}
      expect(last_response.status).to eq(200)
      expect(JSON.parse(last_response.body)).to eq({ 'groups' => [] })
    end
  end

  context 'not empty groups' do
    let!(:group1) { FactoryBot.create :group, building:, name: 'Группа 1' }
    let!(:group2) { FactoryBot.create :group, building:, name: 'Группа 2' }
    let!(:another_group1) { FactoryBot.create :group, building: another_building, name: 'Группа 21' }
    let!(:another_group2) { FactoryBot.create :group, building: another_building, name: 'Группа 22' }

    it 'returns all groups of first building' do
      get "/v1/buildings/#{building.id}/groups", filter: {}
      expect(last_response.status).to eq(200)
      expect(JSON.parse(last_response.body)).to eq({ 'groups' => [{ 'id' => group1.id,
                                                                    'name' => 'Группа 1',
                                                                    'description' => nil },
                                                                  { 'id' => group2.id,
                                                                    'name' => 'Группа 2',
                                                                    'description' => nil }] })
    end
  end
end
