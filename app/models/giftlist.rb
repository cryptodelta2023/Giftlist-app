# frozen_string_literal: true

module GiftListApp
  # Behaviors of the currently logged in account
  class Giftlist
    attr_reader :id, :list_name, # basic info
                :owner, :folowers, :giftinfos, :policies # full details

    def initialize(giftlist_info)
      process_attributes(giftlist_info['attributes'])
      process_relationships(giftlist_info['relationships'])
      process_policies(giftlist_info['policies'])
    end

    private

    def process_attributes(attributes)
      @id = attributes['id']
      @list_name = attributes['list_name']
    end

    def process_relationships(relationships)
      return unless relationships

      @owner = Account.new(relationships['owner'])
      @followers = process_followers(relationships['followers'])
      @giftinfos = process_giftinfos(relationships['giftinfos'])
    end

    def process_policies(policies)
      @policies = OpenStruct.new(policies)
    end

    def process_giftinfos(giftinfos_info)
      return nil unless giftinfos_info

      giftinfos_info.map { |info_info| Giftinfo.new(info_info) }
    end

    def process_followers(followers)
      return nil unless followers

      followers.map { |account_info| Account.new(account_info) }
    end
  end
end
