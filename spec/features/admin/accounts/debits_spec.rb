require 'spec_helper'

feature 'admin/accounts/debits' do
  given!(:user) { create :staff_user }
  given!(:account) { create :account }

  background { sign_in user }

  feature 'admin adds a debit to an account' do
    scenario do
      visit new_admin_account_debits_path(account)

      fill_in :transaction_form_amount_dollars, with: '5'
      fill_in :transaction_form_description, with: 'Test Credit'

      click_button :transaction_form_submit

      expect(page).to have_content('The debit has been added.')
    end
  end
end