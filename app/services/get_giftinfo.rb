# frozen_string_literal: true

require 'http'

module GiftListApp
  # Returns all giftlists belonging to an account
  class GetGiftinfo
    def initialize(config)
      @config = config
    end

    def call(user, info_id)
      response = HTTP.auth("Bearer #{user.auth_token}")
                     .get("#{@config.API_URL}/giftinfos/#{info_id}")

      response.code == 200 ? JSON.parse(response.body.to_s)['data'] : nil
    end
  end
end
