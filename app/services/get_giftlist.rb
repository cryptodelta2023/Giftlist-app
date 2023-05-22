# frozen_string_literal: true

require 'http'

module GiftListApp
  # Returns all giftlists belonging to an account
  class GetGiftlist
    def initialize(config)
      @config = config
    end

    def call(current_account, list_id)
      response = HTTP.auth("Bearer #{current_account.auth_token}")
                     .get("#{@config.API_URL}/giftlists/#{list_id}")

      response.code == 200 ? JSON.parse(response.body.to_s)['data'] : nil
    end
  end
end
