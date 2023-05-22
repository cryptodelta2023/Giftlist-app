# frozen_string_literal: true

require 'http'

module GiftListApp
  # Create a new configuration file for a giftlist
  class CreateNewGiftlist
    def initialize(config)
      @config = config
    end

    def api_url
      @config.API_URL
    end

    def call(current_account:, giftlist_data:)
      config_url = "#{api_url}/giftlists"
      response = HTTP.auth("Bearer #{current_account.auth_token}")
                     .post(config_url, json: giftlist_data)

      response.code == 201 ? JSON.parse(response.body.to_s) : raise
    end
  end
end
