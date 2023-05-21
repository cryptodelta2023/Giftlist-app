# frozen_string_literal: true

require 'roda'

module GiftListApp
  # Web controller for GiftListApp API
  class App < Roda
    route('giftinfos') do |routing|
      routing.redirect '/auth/login' unless @current_account.logged_in?

      # GET /giftinfos/[info_id]
      routing.get(String) do |info_id|
        info_info = GetGiftinfo.new(App.config)
                               .call(@current_account, info_id)
        giftinfo = Giftinfo.new(info_info)

        view :giftinfo, locals: {
          current_account: @current_account, giftinfo: giftinfo
        }
      end
    end
  end
end
