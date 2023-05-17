# frozen_string_literal: true

require_relative 'giftlist'

module GiftListApp
  # Behaviors of the currently logged in account
  class Giftlists
    attr_reader :all

    def initialize(giftlists_list)
      @all = giftlists_list.map do |giftlist|
        Giftlist.new(giftlist)
      end
    end
  end
end
