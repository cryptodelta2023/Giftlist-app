# frozen_string_literal: true

require 'roda'

module GiftListApp
  # Web controller for Credence API
  class App < Roda
    route('giftlists') do |routing|
      routing.on do
        # GET /giftlists/
        routing.get do
          if @current_account.logged_in?
            giftlist_list = GetAllGiftlists.new(App.config).call(@current_account)

            giftlists = Giftlists.new(giftlist_list)

            view :giftlists_all,
                 locals: { current_user: @current_account, giftlists: }
          else
            routing.redirect '/auth/login'
          end
        end
      end
    end
  end
end