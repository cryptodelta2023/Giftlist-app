# frozen_string_literal: true

require_relative 'giftlist'

module GiftListApp
  # Behaviors of the currently logged in account
  class Giftinfo
    attr_reader :id, :giftname, :url, :description, # basic info
                :giftlist # full details

    def initialize(info)
      process_attributes(info['attributes'])
      process_included(info['include'])
    end

    private

    def process_attributes(attributes)
      @id             = attributes['id']
      @giftname       = attributes['giftname']
      @url            = attributes['url']
      @description    = attributes['description']
    end

    def process_included(included)
      @giftlist = Giftlist.new(included['giftlist'])
    end
  end
end
