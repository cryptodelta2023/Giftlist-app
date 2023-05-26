# frozen_string_literal: true

require_relative 'form_base'

module GiftListApp
  module Form
    class NewGiftinfo < Dry::Validation::Contract
      config.messages.load_paths << File.join(__dir__, 'errors/new_giftinfo.yml')

      params do
        optional(:id).maybe(:string)
        required(:giftname).filled.maybe(:string)
        optional(:url).maybe(:string)
        required(:description).maybe(:string)
      end
    end
  end
end
