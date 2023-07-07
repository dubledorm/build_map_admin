# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::TargetsApi, type: :request do
  include Rack::Test::Methods

  let!(:building) { FactoryBot.create :building }
  let!(:another_building) { FactoryBot.create :building }

  def app
    Api::V1::TargetsApi
  end

  context 'empty points' do
    it 'returns an empty array of targets' do
      get "/v1/buildings/#{building.id}/targets", filter: {}
      expect(last_response.status).to eq(200)
      expect(JSON.parse(last_response.body)).to eq({ 'targets' => [] })
    end
  end

  context 'not empty points' do
    let!(:building_part) { FactoryBot.create :building_part, building: }
    let!(:another_building_part) { FactoryBot.create :building_part, building: another_building }
    let!(:point1) { FactoryBot.create :point, building_part:, name: 'Первая точка первый этаж' }
    let!(:point2) { FactoryBot.create :point, building_part:, name: 'Вторая точка первый этаж' }
    let!(:another_point1) { FactoryBot.create :point, building_part: another_building_part, name: 'Первая точка второй этаж' }
    let!(:another_point2) { FactoryBot.create :point, building_part: another_building_part, name: 'Вторая точка второй этаж' }

    it 'returns all points of first floor' do
      get "/v1/buildings/#{building.id}/targets", filter: {}
      expect(last_response.status).to eq(200)
      expect(JSON.parse(last_response.body)).to eq({ 'targets' => [{ 'id' => point1.id,
                                                                     'name' => 'Первая точка первый этаж' },
                                                                   { 'id' => point2.id,
                                                                     'name' => 'Вторая точка первый этаж' }] })
    end

    it 'returns one point of first floor' do
      get "/v1/buildings/#{building.id}/targets", filter: { target_name: 'Первая' }
      expect(last_response.status).to eq(200)
      expect(JSON.parse(last_response.body)).to eq({ 'targets' => [{ 'id' => point1.id,
                                                                     'name' => 'Первая точка первый этаж' }] })
    end
  end
end
