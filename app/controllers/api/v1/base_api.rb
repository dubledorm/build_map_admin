# frozen_string_literal: true

class Api
  class V1
    # Базовый класс для методов API версии 1
    class BaseApi < Grape::API
      rescue_from :all
    end
  end
end
