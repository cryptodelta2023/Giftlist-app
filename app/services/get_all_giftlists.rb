# frozen_string_literal: true

require 'http'

module GiftListApp
  # Returns all giftlists belonging to an account
  class GetAllGiftlists
    def initialize(config)
      @config = config
    end

    def call(current_account, own_or_follow = '')
      response = if own_or_follow == ''
                   HTTP.auth("Bearer #{current_account.auth_token}")
                       .get("#{@config.API_URL}/giftlists")
                 else
                   HTTP.auth("Bearer #{current_account.auth_token}")
                       .get("#{@config.API_URL}/giftlists/#{own_or_follow}")
                 end

      response.code == 200 ? JSON.parse(response.to_s)['data'] : nil
    end
  end
end
