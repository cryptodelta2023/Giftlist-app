# frozen_string_literal: true

require 'roda'
require_relative './app'

module GiftListApp
  # Web controller for Giftlist API
  class App < Roda
    route('giftlists') do |routing|
      routing.on do
        routing.redirect '/auth/login' unless @current_account.logged_in?
        @giftlists_route = '/giftlists'

        routing.on(String) do |list_id|
          @giftlist_route = "#{@giftlists_route}/#{list_id}"
          routing.is do
            # POST /giftlists/[list_id]

            routing.post do
              action = routing.params['action']
              new_list_name = routing.params['new_list_name']
              giftlist_data = Form::NewGiftlist.new.call(routing.params)
              if giftlist_data.failure?
                flash[:error] = Form.validation_errors(giftlist_data)
                routing.halt
              end

              task_list = {
                'edit' => { service: EditGiftlist,
                            message: 'Edit the name of giftlist',
                            redirect_route: @giftlist_route,
                            err_msg: "Edit giftlist error, your input should not be empty or the list name already exists" },
                'delete' => { service: DeleteGiftlist,
                              message: 'Removed giftlist',
                              redirect_route: '/giftlists/myown',
                              err_msg: "Can't delete now! Please try it later🙏" }
              }

              task = task_list[action]

              task[:service].new(App.config).call(
                current_account: @current_account,
                new_list_name:,
                giftlist_id: list_id
              )
              flash[:notice] = task[:message]

            rescue StandardError
              flash[:error] = task[:err_msg]
            ensure
              routing.redirect task[:redirect_route]
            end

            # GET /giftlists/[list_id]
            routing.get do
              if %w[myown following].include?(list_id)
                giftlist_list = GetAllGiftlists.new(App.config).call(@current_account, list_id)

                giftlists = Giftlists.new(giftlist_list)
                if list_id == 'myown'
                  view :giftlists_myown, locals: {
                    current_account: @current_account, giftlists:
                  }
                elsif list_id == 'following'
                  view :giftlists_following, locals: {
                    current_account: @current_account, giftlists:
                  }
                end
              else
                list_info = GetGiftlist.new(App.config).call(
                  @current_account, list_id
                )
                giftlist = Giftlist.new(list_info)

                view :giftlist, locals: {
                  current_account: @current_account, giftlist:
                }
              end
            rescue StandardError => e
              puts "#{e.inspect}\n#{e.backtrace}"
              flash[:error] = 'Giftlist not found'
              routing.redirect @giftlist_route
            end
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

          rescue StandardError => e
            flash[:error] = e.message
          rescue FollowerIsOwner => e
            flash[:error] = e.message
          rescue FollowerAlreadyAdded => e
            flash[:error] = e.message
          ensure
            routing.redirect @giftlist_route
          end

          # POST /giftlists/[list_id]/giftinfos
          routing.post('giftinfos') do
            action = routing.params['action']
            giftinfo_data = Form::NewGiftinfo.new.call(routing.params)
            if giftinfo_data.failure?
              flash[:error] = Form.message_values(giftinfo_data)
              routing.halt
            end

            task_list = {
              'add' => { service: CreateNewGiftinfo,
                         message: 'Added new giftinfo to giftlist' },
              'remove' => { service: RemoveGiftinfo,
                            message: 'Removed giftinfo from giftlist' }
            }

            task = task_list[action]
            task[:service].new(App.config).call(
              current_account: @current_account,
              giftinfo_data: giftinfo_data.to_h,
              giftlist_id: list_id
            )

            flash[:notice] = task[:message]
          rescue StandardError => e
            puts "ERROR IN #{action} GiftInfo: #{e.inspect}"
            flash[:error] = "Could not #{action} giftinfo"
          ensure
            routing.redirect @giftlist_route
          end
        end

        # GET /giftlists/
        routing.get do
          giftlist_list = GetAllGiftlists.new(App.config).call(@current_account)

          giftlists = Giftlists.new(giftlist_list)

          view :giftlists_choose, locals: {
            current_account: @current_account, giftlists:
          }
        end

        # POST /giftlists/
        routing.post do
          routing.redirect '/auth/login' unless @current_account.logged_in?
          # puts "LIST: #{routing.params}"
          giftlist_data = Form::NewGiftlist.new.call(routing.params)
          if giftlist_data.failure?
            flash[:error] = Form.message_values(giftlist_data)
            routing.halt
          end
          CreateNewGiftlist.new(App.config).call(
            current_account: @current_account,
            giftlist_data: giftlist_data.to_h
          )

          flash[:notice] = 'Giftlist created, please add giftinfos and followers to your new giftlist'
        rescue StandardError => e
          flash[:error] = 'Could not create giftlist, list name might be duplicated'
        ensure
          routing.redirect '/giftlists/myown'
        end
      end
    end
  end
end
