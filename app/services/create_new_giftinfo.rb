# frozen_string_literal: true

require 'http'

module GiftListApp
  # Create a new configuration file for a giftlist
  class CreateNewGiftinfo
    def initialize(config)
      @config = config
    end

    def api_url
      @config.API_URL
    end

    def call(current_account:, giftlist_id:, giftinfo_data:)
      config_url = "#{api_url}/giftlists/#{giftlist_id}/giftinfos"
      response = HTTP.auth("Bearer #{current_account.auth_token}")
                     .post(config_url, json: giftinfo_data)

      response.code == 201 ? JSON.parse(response.body.to_s) : raise
    end
  end
end
