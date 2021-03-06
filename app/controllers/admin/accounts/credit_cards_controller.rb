module Admin
  module Accounts
    class CreditCardsController < Admin::Accounts::ApplicationController
      decorates_assigned :credit_card

      before_filter :ensure_access

      def show
        credit_card_reader.on(:read_success) do |credit_card|
          @credit_card = credit_card
        end
        credit_card_reader.on(:read_failure) do
          redirect_to [:edit, :admin, account, :credit_cards]
        end

        credit_card_reader.read
      end

      def edit
        credit_card_reader.on(:read_success) do |credit_card|
          @credit_card = credit_card
        end
        credit_card_reader.on(:read_failure) do
          @credit_card = ::Accounts::CreditCard.new(@account.credit_card_defaults)
        end

        credit_card_reader.read
      end

      def update
        credit_card_updater.on(:update_success) do
          flash[:notice] = 'Your credit card has been updated.'
          redirect_to [:admin, account, :credit_cards]
        end
        credit_card_updater.on(:update_failure) do |credit_card|
          @credit_card = credit_card
          render :edit
        end

        credit_card_updater.update(credit_card_params)
      end

      private
      def credit_card_reader
        @credit_card_reader ||= ::Accounts::CreditCardReader.new(account: @account)
      end

      def credit_card_updater
        @credit_card_updater ||= ::Accounts::CreditCardUpdater.new(account: @account, user: current_user, request: request, event_logger: account_event_logger)
      end

      def ensure_access
        current_power.admin_account_credit_card!(account)
      end

      def credit_card_params
        params.require(:credit_card).permit(:token, :address_line1, :address_line2, :address_city, :address_state,
                                            :address_zip, :address_country, :name, :expiration_month, :expiration_year)
      end
    end
  end
end