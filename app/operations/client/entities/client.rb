# frozen_string_literal: true

module Client
  module Entities
    # Класс, содержащий данные о клиенте
    class Client
      include ActiveModel::Model

      attr_accessor :organization, :users

      def initialize(organization)
        @organization = organization
      end

      def self.columns
        %i[organization, users]
      end

      def attributes
        { 'users' => @users,
          'organization' => @organization }
      end
    end
  end
end
