# frozen_string_literal: true

require 'rails_helper'

describe 'Transaction' do
  include TransactionsHelpers
  subject { page }

  login_manager

  let!(:owner_one) { create(:user, :owner) }
  let!(:house_one) { create(:house, owner: owner_one, maintenance: true) }
  let!(:transaction) do
    create(:transaction, house: house_one, user_id: owner_one.id, type: create(:transaction_type, :rental))
  end

  context 'when open index page' do
    let(:house_two) { create(:house, owner: owner_one) }
    let!(:another_trsc) { create(:transaction, house: house_two, user_id: owner_one.id) }

    context "when transactions filter" do
      before do
        visit transactions_path(from: 1.day.ago.to_date.to_s,
                                to: 1.day.from_now.to_date.to_s,
                                owner_id: transaction.user_id,
                                house_id: transaction.house_id)
      end

      it { is_expected.not_to have_selector('td', text: another_trsc.house.code) }
      it { is_expected.to have_selector('td', text: transaction.house.code) }
    end
  end

  context 'when new transaction', js: true do
    before { add_salary_type }

    context 'when cleaning' do
      let!(:type_one) { create(:transaction_type, :cleaning) }
      let!(:house_two) { create(:house, owner: create(:user, :owner)) }

      before do
        add_transaction(date: Date.current - 3.day,
                        type: type_one.name_en,
                        house_code: house_two.code,
                        de_co: 1_070)
      end

      context 'when not params' do
        before do
          visit transactions_path
        end

        it { is_expected.to have_selector("tr#trsc_#{type_one.transactions.first.id}_row") }
        it { is_expected.to have_selector('td.de_co_cell', text: '1,070.00') }
        it { is_expected.to have_selector('td.comment', text: type_one.transactions.first.comment_en) }
      end

      context 'when with params' do
        before do
          visit transactions_path(owner_id: house_two.owner_id)
        end

        it { is_expected.to have_selector("tr#trsc_#{type_one.transactions.first.id}_row") }
        it { is_expected.to have_selector('td.cr_ow_cell', text: '1,070.00') }
        it { is_expected.not_to have_selector('td.comment', text: transaction.comment_en) }
      end
    end

    context 'when new welcome_packs transaction' do
      let!(:type_two) { create(:transaction_type, :welcome_packs) }

      before do
        add_transaction(type: type_two.name_en, house_code: house_one.code, de_co: 330)
        sign_in house_one.owner
      end

      context 'when view welcome_packs' do
        before do
          visit transactions_path
        end

        it { is_expected.to have_selector("tr#trsc_#{type_two.transactions.first.id}_row") }
        it { is_expected.to have_selector('td.cr_ow_cell', text: '330.00') }
        it { is_expected.to have_selector('td.comment', text: type_two.transactions.first.comment_en) }
      end
    end
  end
end
