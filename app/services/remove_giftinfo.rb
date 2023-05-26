# frozen_string_literal: true

module GiftListApp
  # Service to add follower to giftlist
  class RemoveGiftinfo
    class GiftinfoNotRemoved < StandardError; end

    def initialize(config)
      @config = config
    end

    def api_url
      @config.API_URL
    end

    def call(current_account:, giftinfo_data:, giftlist_id:)
      response = HTTP.auth("Bearer #{current_account.auth_token}")
                     .delete("#{api_url}/giftlists/#{giftlist_id}/giftinfos",
                             json: { giftinfo_id: giftinfo_data[:id] })

      raise GiftinfoNotRemoved unless response.code == 200
    end
  end
end
