# frozen_string_literal: true

require 'roda'

module GiftListApp
  # Web controller for Giftlist API
  class App < Roda
    route('giftlists') do |routing|
      routing.on do
        routing.redirect '/auth/login' unless @current_account.logged_in?
        @giftlists_route = '/giftlists'

        routing.on(String) do |list_id|
          @giftlist_route = "#{@giftlists_route}/#{list_id}"

          # GET /giftlists/[list_id]
          routing.get do
            list_info = GetGiftlist.new(App.config).call(
              @current_account, list_id
            )
            giftlist = Giftlist.new(list_info)
            p giftlist
            p giftlist.followers
            p "-------"

            view :giftlist, locals: {
              current_account: @current_account, giftlist: giftlist
            }
          rescue StandardError => e
            puts "#{e.inspect}\n#{e.backtrace}"
            flash[:error] = 'Giftlist not found'
            routing.redirect @giftlists_route
          end

          # POST /giftlists/[list_id]/followers
          routing.post('followers') do
            action = routing.params['action']
            follower_info = Form::FollowerEmail.new.call(routing.params)
            if follower_info.failure?
              flash[:error] = Form.validation_errors(follower_info)
              routing.halt
            end

            task_list = {
              'add' => { service: AddFollower,
                         message: 'Added new follower to giftlist' },
              'remove' => { service: RemoveFollower,
                            message: 'Removed follower from giftlist' }
            }

            task = task_list[action]
            task[:service].new(App.config).call(
              current_account: @current_account,
              follower: follower_info,
              giftlist_id: list_id
            )
            flash[:notice] = task[:message]

          rescue StandardError
            flash[:error] = 'Could not find follower'
          ensure
            routing.redirect @giftlist_route
          end

          # POST /giftlists/[list_id]/giftinfos/
          routing.post('giftinfos') do
            giftinfo_data = Form::NewGiftinfo.new.call(routing.params)
            if giftinfo_data.failure?
              flash[:error] = Form.message_values(giftinfo_data)
              routing.halt
            end

            CreateNewGiftinfo.new(App.config).call(
              current_account: @current_account,
              giftlist_id: list_id,
              giftinfo_data: giftinfo_data.to_h
            )

            flash[:notice] = 'Your giftinfo was added'
          rescue StandardError => error
            puts error.inspect
            puts error.backtrace
            flash[:error] = 'Could not add giftinfo'
          ensure
            routing.redirect @giftlist_route
          end
        end

        # GET /giftlists/
        routing.get do
          giftlist_list = GetAllGiftlists.new(App.config).call(@current_account)

          giftlists = Giftlists.new(giftlist_list)

          view :giftlists_all, locals: {
            current_account: @current_account, giftlists: giftlists
          }
        end

        # POST /giftlists/
        routing.post do
          routing.redirect '/auth/login' unless @current_account.logged_in?
          puts "LIST: #{routing.params}"
          giftlist_data = Form::NewGiftlist.new.call(routing.params)
          if giftlist_data.failure?
            flash[:error] = Form.message_values(giftlist_data)
            routing.halt
          end
          CreateNewGiftlist.new(App.config).call(
            current_account: @current_account,
            giftlist_data: giftlist_data.to_h
          )

          flash[:notice] = 'Add giftinfos and followers to your new giftlist'
        rescue StandardError => e
          puts "FAILURE Creating Giftlist: #{e.inspect}"
          flash[:error] = 'Could not create giftlist'
        ensure
          routing.redirect @giftlists_route
        end
      end
    end
  end
end
