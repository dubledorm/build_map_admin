# frozen_string_literal: true

class Api::V1 < Grape::API
  format :json
  content_type :json, 'application/json; charset=utf-8'
  include Grape::Extensions::ActiveSupport::HashWithIndifferentAccess::ParamBuilder

  version 'v1'

  namespace 'buildings' do
    route_param :building_id, type: Integer, desc: 'Id здания/локации' do
      mount TargetsApi
    end

    before do
      @building = Building.find(params[:building_id])
    end
  end
  add_swagger_documentation
end
