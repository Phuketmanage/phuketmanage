# frozen_string_literal: true

require 'rails_helper'

describe 'Transaction' do
  include TransactionsHelpers
  subject { page }

  login_manager

  let!(:owner) { create(:user, :owner) }
  let!(:house) { create(:house, owner: owner) }
  let!(:transaction) do
    create(:transaction, house: house, user_id: owner.id, type: create(:transaction_type, :rental))
  end

  context 'when open index page' do
    let!(:house_two) { create(:house, owner: owner) }
    let!(:another_tx) { create(:transaction, house: house_two, user_id: owner.id) }

    context "when transactions filter" do
      before do
        visit transactions_path(from: 1.day.ago.to_date.to_s,
                                to: 1.day.from_now.to_date.to_s,
                                owner_id: transaction.user_id,
                                house_id: transaction.house_id)
      end

      it { is_expected.not_to have_css('td', text: another_tx.house.code) }
      it { is_expected.to have_css('td', text: transaction.house.code) }
    end
  end

  context 'when new transaction', js: true do
    context 'when cleaning' do
      let!(:type_cleaning) { create(:transaction_type, :cleaning) }

      before do
        add_transaction(type: type_cleaning.name_en, house_code: house.code,
                        de_co: 1_070, comment_en: 'Clean windows', comment_ru: 'Очистка окон')
      end

      context 'when manager open balance of company' do
        before { sleep 0.2; visit transactions_path }

        it { is_expected.to have_selector("tr#trsc_#{Transaction.last.id}_row") }
        it { is_expected.to have_css('td.de_co_cell', text: '1,070.00') }
        it { is_expected.to have_css('td.comment', text: 'Clean windows') }
      end

      context 'when manager open balance of owner' do
        before { sleep 0.2; visit transactions_path(owner_id: owner.id) }

        it { is_expected.to have_selector("tr#trsc_#{Transaction.last.id}_row") }
        it { is_expected.to have_css('td.cr_ow_cell', text: '1,070.00') }
        it { is_expected.to have_css('td.comment', text: 'Clean windows') }
      end

      context 'when the owner opens his balance' do
        before do
          sleep 0.3
          sign_in owner
          visit transactions_path
        end

        it { is_expected.to have_selector("tr#trsc_#{Transaction.last.id}_row") }
        it { is_expected.to have_css('td.cr_ow_cell', text: '1,070.00') }
        it { is_expected.to have_css('td.comment', text: 'Clean windows') }
      end
    end

    context 'when new welcome_packs transaction' do
      let!(:type_welcome_packs) { create(:transaction_type, :welcome_packs) }

      before do
        add_transaction(type: type_welcome_packs.name_en, house_code: house.code, de_co: 330,
                        comment_en: 'Some welcome packs', comment_ru: 'Один приветственный набор')
      end

      context 'when manager open balance of company' do
        before { sleep 0.2; visit transactions_path }

        it { is_expected.to have_selector("tr#trsc_#{Transaction.last.id}_row") }
        it { is_expected.to have_css('td.de_co_cell', text: '330.00') }
        it { is_expected.to have_css('td.comment', text: 'Some welcome packs') }
      end

      context 'when manager open balance of owner' do
        before { sleep 0.2; visit transactions_path(owner_id: owner.id) }

        it { is_expected.to have_selector("tr#trsc_#{Transaction.last.id}_row") }
        it { is_expected.to have_css('td.cr_ow_cell', text: '330.00') }
        it { is_expected.to have_css('td.comment', text: 'Some welcome packs') }
      end

      context 'when owner open balance' do
        before do
          sleep 0.3
          sign_in owner
          visit transactions_path
        end

        it { is_expected.to have_selector("tr#trsc_#{Transaction.last.id}_row") }
        it { is_expected.to have_css('td.cr_ow_cell', text: '330.00') }
        it { is_expected.to have_css('td.comment', text: 'Some welcome packs') }
      end
    end
  end
end
