# frozen_string_literal: true

module GiftListApp
  # Service to add follower to giftlist
  class AddFollower
    # follower not registered
    class FollowerNotFound < StandardError
      def message
        'This follower does not exist'
      end
    end

    # follower cannot be owner
    class FollowerIsOwner < StandardError
      def message
        'You are not allowed to add yourself as a follower'
      end
    end

    # follower already on the following list
    class FollowerAlreadyAdded < StandardError
      def message
        'This follower is already on the following list'
      end
    end

    def initialize(config)
      @config = config
    end

    def api_url
      @config.API_URL
    end

    def call(current_account:, follower:, giftlist_id:)
      response = HTTP.auth("Bearer #{current_account.auth_token}")
                     .put("#{api_url}/giftlists/#{giftlist_id}/followers",
                          json: { email: follower[:email] })
      # print(JSON.parse(response.to_s)['message'])
      raise FollowerNotFound if response.code == 500
      raise FollowerIsOwner if response.code == 400
      raise FollowerAlreadyAdded if response.code == 403
    end
  end
end
