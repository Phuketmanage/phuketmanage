# frozen_string_literal: true

# rubocop:disable RSpec/MultipleMemoizedHelpers

require 'rails_helper'

describe 'Booking' do
  subject { page }

  let(:current_date) { Date.current }
  let(:date_start) { current_date }
  let(:date_finish) { current_date + 10.days }

  context 'when user is admin' do
    login_admin

    let!(:booking_pending) do
      create(:booking, :pending, house: create(:house, :with_seasons), start: date_start, finish: date_finish)
    end
    let!(:booking_pending2) do
      create(:booking, :pending, house: create(:house, :with_seasons), start: date_start, finish: date_finish)
    end
    let!(:booking_canceled) do
      create(:booking, :canceled, house: create(:house, :with_seasons), start: date_start, finish: date_finish)
    end

    context "when visiting bookings" do
      before do
        visit "/bookings?from=#{current_date}&to=#{current_date + 2.years}"
      end

      it { is_expected.to have_text("Bookings (2)") }
      it { is_expected.to have_selector('td', text: booking_pending.house.code) }
      it { is_expected.to have_selector('td', text: booking_pending2.house.code) }
      it { is_expected.not_to have_selector('td', text: booking_canceled.house.code) }
    end

    context "when visiting admin bookings with hid params" do
      before do
        visit "/bookings?from=#{current_date}&to=#{current_date + 2.years}&hid=#{booking_pending.house.id}"
      end

      it { is_expected.to have_text("Bookings (1)") }
      it { is_expected.to have_selector('td', text: booking_pending.house.code) }
      it { is_expected.not_to have_selector('td', text: booking_pending2.house.code) }
      it { is_expected.not_to have_selector('td', text: booking_canceled.house.code) }
    end

    context "when visiting canceled bookings" do
      before do
        visit "/bookings/canceled?from=#{current_date}&to=#{current_date + 2.years}"
      end

      it { is_expected.to have_text("Canceled bookings (1)") }
      it { is_expected.to have_selector('td', text: booking_canceled.house.code) }
      it { is_expected.not_to have_selector('td', text: booking_pending.house.code) }
    end

    context "when visiting dashboard view" do
      before { visit dashboard_path }

      it { is_expected.to have_text("Pending Bookings") }
      it { is_expected.to have_selector('b', text: booking_pending.house.rooms) }
      it { is_expected.to have_selector('b', text: booking_pending2.house.rooms) }
      it { is_expected.to have_selector("div[data-id='#{booking_pending.id}']", count: 1) }
      it { is_expected.to have_selector("div[data-id='#{booking_pending2.id}']", count: 1) }
      it { is_expected.not_to have_selector("div[data-id='#{booking_canceled.id}']") }
    end
  end

  context 'when user is owner' do
    let(:owner_one) { create(:user, :owner) }
    let(:owner_two) { create(:user, :owner) }

    let(:house_one) { create(:house, :with_seasons, owner: owner_one) }
    let(:house_two) { create(:house, :with_seasons, owner: owner_one) }
    let(:house_three) { create(:house, :with_seasons, owner: owner_two) }

    before do
      create(:booking, :pending, house: house_one, start: date_start, finish: date_finish,
                       sale: 10_000, agent: 0, comm: 2_000, nett: 8_000)
      create(:booking, :confirmed, house: house_two, start: date_start, finish: date_finish + 2.days,
                       sale: 12_000, agent: 0, comm: 2_400, nett: 9_600)
      create(:booking, :pending, house: house_three, start: date_start, finish: date_finish,
                       sale: 20_000, agent: 2_000, comm: 2_000, nett: 16_000)
      create(:booking, :pending, house: house_three, start: date_start + 12.days, finish: date_finish + 14.days,
                       sale: 30_000, agent: 0, comm: 6_000, nett: 24_000)
    end

    context "when owner_one" do
      before do
        sign_in owner_one
        visit "/owner/bookings?from=#{current_date}&to=#{current_date + 2.years}&commit=Show"
      end

      it { is_expected.to have_text("Bookings (2)") }
      it { is_expected.to have_selector('tr.booking_row', count: 2) }
      it { is_expected.to have_selector('td', text: house_one.code) }
      it { is_expected.to have_selector('td', text: house_two.code) }
      it { is_expected.not_to have_selector('td', text: house_three.code) }
      it { is_expected.to have_selector('td', text: '10') }
      it { is_expected.to have_selector('td', text: '12') }
      it { is_expected.to have_selector('td', text: '8,000') }
      it { is_expected.to have_selector('td', text: '9,600') }
    end

    context "when owner_two" do
      before do
        sign_in owner_two
        visit "/owner/bookings?from=#{current_date}&to=#{current_date + 2.years}&commit=Show"
      end

      it { is_expected.to have_text("Bookings (2)") }
      it { is_expected.to have_selector('tr.booking_row', count: 2) }
      it { is_expected.not_to have_selector('td', text: house_one.code) }
      it { is_expected.not_to have_selector('td', text: house_two.code) }
      it { is_expected.to have_selector('td', text: '10') }
      it { is_expected.to have_selector('td', text: '12') }
      it { is_expected.to have_selector('td', text: '16,000') }
      it { is_expected.to have_selector('td', text: '24,000') }
    end
  end
end
