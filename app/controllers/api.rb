# frozen_string_literal: true

class Api < Grape::API

  mount ::Api::V1
end
