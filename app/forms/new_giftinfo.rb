# frozen_string_literal: true

require_relative 'form_base'

module GiftListApp
  module Form
    class NewGiftinfo < Dry::Validation::Contract
      config.messages.load_paths << File.join(__dir__, 'errors/new_giftinfo.yml')

      params do
        # required(:id).filled(max_size?: 256, format?: FILENAME_REGEX)
        required(:giftname).filled.maybe(:string)
        required(:url).maybe(:string)
        required(:description).filled(:string)
      end
    end
  end
end
