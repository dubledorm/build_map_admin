# frozen_string_literal: true

require 'uri'

module PrintClient
  # Доступ к функциям data_to_Document сервиса.  class HttpService
  class HttpService
    include ActiveModel::Validations

    DOCUMENTS_PATH = 'cdn/documents'

    class NotFoundError < StandardError; end
    class Error < StandardError; end

    attr_accessor :data_to_document_url

    def initialize
      @data_to_document_url = Settings.data_to_document.base_url
    end

    def report!(template_name, data_hash)
      response = faraday_post(template_name, data_hash)
      response.body
    rescue StandardError => e
      raise Error, e.message
    end

    protected

    def make_url(*args)
      parts = args.map { |part| part.end_with?('/') ? part[0..-2] : part }
      parts.join('/')
    end

    def faraday_post(template_name, data_hash)
      target_url = make_url(@data_to_document_url, DOCUMENTS_PATH, template_name).to_s
      response = Faraday.post(target_url) do |req|
        req.headers['Content-Type'] = 'application/json'
        req.headers['accept'] = 'text/plain'
        req.body = data_hash.to_json
      end

      raise Error, response.body unless response.status == 200

      response
    end
  end
end
