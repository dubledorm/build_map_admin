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

  context 'when points in two buildings' do
    let!(:building_part) { FactoryBot.create :building_part, building: }
    let!(:another_building_part) { FactoryBot.create :building_part, building: another_building }
    let!(:point1) { FactoryBot.create :point, building_part:, name: 'Первая точка первое строение' }
    let!(:point2) { FactoryBot.create :point, building_part:, name: 'Вторая точка первое строение' }
    let!(:another_point1) { FactoryBot.create :point, building_part: another_building_part, name: 'Первая точка второе строение' }
    let!(:another_point2) { FactoryBot.create :point, building_part: another_building_part, name: 'Вторая точка второе строение' }

    it 'returns all points of first floor' do
      get "/v1/buildings/#{building.id}/targets", filter: {}
      expect(last_response.status).to eq(200)
      expect(JSON.parse(last_response.body)).to eq({ 'targets' => [{ 'id' => point1.id,
                                                                     'name' => 'Первая точка первое строение' },
                                                                   { 'id' => point2.id,
                                                                     'name' => 'Вторая точка первое строение' }] })
    end

    it 'returns one point of first floor' do
      get "/v1/buildings/#{building.id}/targets", filter: { target_name: 'Первая' }
      expect(last_response.status).to eq(200)
      expect(JSON.parse(last_response.body)).to eq({ 'targets' => [{ 'id' => point1.id,
                                                                     'name' => 'Первая точка первое строение' }] })
    end

    it 'use limit' do
      get "/v1/buildings/#{building.id}/targets", limit: 1
      expect(last_response.status).to eq(200)
      expect(JSON.parse(last_response.body)['targets'].count).to eq(1)
    end
  end


  context 'when points in one building but two floors' do
    let!(:building_part) { FactoryBot.create :building_part, building: }
    let!(:another_building_part) { FactoryBot.create :building_part, building: }
    let!(:point1) { FactoryBot.create :point, building_part:, name: 'Первая точка первое строение' }
    let!(:point2) { FactoryBot.create :point, building_part:, name: 'Вторая точка первое строение' }
    let!(:point21) { FactoryBot.create :point, building_part: another_building_part, name: 'Первая точка второй этаж' }
    let!(:point22) { FactoryBot.create :point, building_part: another_building_part, name: 'Вторая точка второй этаж' }

    it 'returns all points of all floors' do
      get "/v1/buildings/#{building.id}/targets", filter: {}
      expect(last_response.status).to eq(200)
      expect(JSON.parse(last_response.body)).to eq({ 'targets' => [{ 'id' => point1.id,
                                                                     'name' => 'Первая точка первое строение' },
                                                                   { 'id' => point2.id,
                                                                     'name' => 'Вторая точка первое строение' },
                                                                   { 'id' => point21.id,
                                                                     'name' => 'Первая точка второй этаж' },
                                                                   { 'id' => point22.id,
                                                                     'name' => 'Вторая точка второй этаж' }] })
    end

    it 'returns one point of first floor' do
      get "/v1/buildings/#{building.id}/targets", filter: { target_name: 'Первая' }
      expect(last_response.status).to eq(200)
      expect(JSON.parse(last_response.body)).to eq({ 'targets' => [{ 'id' => point1.id,
                                                                     'name' => 'Первая точка первое строение' },
                                                                   { 'id' => point21.id,
                                                                     'name' => 'Первая точка второй этаж' }] })
    end
  end


  context 'when some group exists' do
    let!(:building_part) { FactoryBot.create :building_part, building: }
    let!(:another_building_part) { FactoryBot.create :building_part, building: }
    let!(:point1) { FactoryBot.create :point, building_part:, name: 'Первая точка первое строение' }
    let!(:point2) { FactoryBot.create :point, building_part:, name: 'Вторая точка первое строение' }
    let!(:point21) { FactoryBot.create :point, building_part: another_building_part, name: 'Первая точка второй этаж' }
    let!(:point22) { FactoryBot.create :point, building_part: another_building_part, name: 'Вторая точка второй этаж' }
    let!(:group1) { FactoryBot.create :group, building:, name: 'Группа 1' }
    let!(:group2) { FactoryBot.create :group, building:, name: 'Группа 2' }

    before do
      point1.groups << group1
      point22.groups << group1
    end

    it 'returns points of one group' do
      get "/v1/buildings/#{building.id}/targets", filter: { group_id: group1.id }
      expect(last_response.status).to eq(200)
      expect(JSON.parse(last_response.body)).to eq({ 'targets' => [{ 'id' => point1.id,
                                                                     'name' => 'Первая точка первое строение' },
                                                                   { 'id' => point22.id,
                                                                     'name' => 'Вторая точка второй этаж' }] })
    end

    it 'returns points of one group and filter by name' do
      get "/v1/buildings/#{building.id}/targets", filter: { group_id: group1.id, target_name: 'Первая' }
      expect(last_response.status).to eq(200)
      expect(JSON.parse(last_response.body)).to eq({ 'targets' => [{ 'id' => point1.id,
                                                                     'name' => 'Первая точка первое строение' }] })
    end
  end
end
