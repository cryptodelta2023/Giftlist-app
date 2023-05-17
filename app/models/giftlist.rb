# frozen_string_literal: true

module GiftListApp
  # Behaviors of the currently logged in account
  class Giftlist
    attr_reader :id, :list_name

    def initialize(giftlist_info)
      @id = giftlist_info['attributes']['id']
      @list_name = giftlist_info['attributes']['list_name']
    end
  end
end
