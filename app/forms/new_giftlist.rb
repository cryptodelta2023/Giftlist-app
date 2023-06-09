# frozen_string_literal: true

require_relative 'form_base'

module GiftListApp
  module Form
    class NewGiftlist < Dry::Validation::Contract
      config.messages.load_paths << File.join(__dir__, 'errors/new_giftlist.yml')

      params do
        # required(:id).filled
        required(:list_name).filled
        # optional(:list_name).maybe(format?: URI::DEFAULT_PARSER.make_regexp)
      end
    end
  end
end
