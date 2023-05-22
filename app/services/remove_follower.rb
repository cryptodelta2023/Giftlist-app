# frozen_string_literal: true

module GiftListApp
  # Service to add follower to giftlist
  class RemoveFollower
    class FollowerNotRemoved < StandardError; end

    def initialize(config)
      @config = config
    end

    def api_url
      @config.API_URL
    end

    def call(current_account:, follower:, giftlist_id:)
      response = HTTP.auth("Bearer #{current_account.auth_token}")
                     .delete("#{api_url}/giftlists/#{giftlist_id}/followers",
                             json: { email: follower[:email] })

      raise FollowerNotRemoved unless response.code == 200
    end
  end
end
