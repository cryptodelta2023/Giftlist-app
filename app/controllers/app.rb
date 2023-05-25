# frozen_string_literal: true

require 'roda'
require 'slim'
require 'slim/include'
require 'rack/session'

module GiftListApp
  # Base class for GiftListApp Web Application
  class App < Roda
    plugin :render, engine: 'slim', views: 'app/presentation/views'
    plugin :assets, css: 'style.css', path: 'app/presentation/assets'
    plugin :public, root: 'app/presentation/public'
    plugin :multi_route
    plugin :flash

    route do |routing|
      p "++++++"
      response['Content-Type'] = 'text/html; charset=utf-8'
      p response
      @current_account = CurrentSession.new(session).current_account

      routing.public
      routing.assets
      routing.multi_route

      # GET /
      routing.root do
        view 'home', locals: { current_account: @current_account }
      end
    end
  end
end
