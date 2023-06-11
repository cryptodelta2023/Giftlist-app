# frozen_string_literal: true

require 'http'

module GiftListApp
  # Returns all giftlists belonging to an account
  class EditGiftlist
    def initialize(config)
      @config = config
    end

    def api_url
      @config.API_URL
    end

    def call(current_account:, new_list_name: , giftlist_id:)
      config_url = "#{api_url}/giftlists/#{giftlist_id}"
      response = HTTP.auth("Bearer #{current_account.auth_token}")
                     .post(config_url,
                           json: { new_list_name:, giftlist_id: })
      
      response.code == 200 ? JSON.parse(response.body.to_s)['data'] : nil
    end
  end
end
