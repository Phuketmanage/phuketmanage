# frozen_string_literal: true

require 'rails_helper'

describe 'Hotkeys' do
  let(:admin) { create(:user, :admin) }
  let(:manager) { create(:user, :manager) }
  let(:accounting) { create(:user, :accounting) }
  let(:owner) { create(:user, :owner) }

  describe 'Transaction index page', js: true do
    let(:start_page) { transactions_path }
    let(:desired_page) { new_transaction_path(locale: :en) }
    let(:keys) { [:shift, 'a'] }

    context 'when pressed Shift+A' do
      context 'when admin' do
        it "opens new transaction page" do
          sign_in admin
          visit start_page
          page.send_keys keys
          expect(page).to have_current_path(desired_page)
        end
      end

      context 'when accounting' do
        it "opens new transaction page" do
          sign_in manager
          visit start_page
          page.send_keys keys
          expect(page).to have_current_path(desired_page)
        end
      end

      context 'when accounting' do
        it "opens new transaction page" do
          sign_in accounting
          visit start_page
          page.send_keys keys
          expect(page).to have_current_path(desired_page)
        end
      end
    end

    context 'when only A pressed' do
      let(:keys) { ['a'] }

      it "doese nothing" do
        sign_in admin
        visit start_page
        page.send_keys keys
        expect(page).to have_current_path(start_page)
      end
    end
  end
end
