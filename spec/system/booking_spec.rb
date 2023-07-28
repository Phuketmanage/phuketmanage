# frozen_string_literal: true

# rubocop:disable RSpec/MultipleMemoizedHelpers

require 'rails_helper'

describe 'Booking', js: true do
  current_date = Time.zone.today
  let(:owner_one) { create(:user, :owner) }
  let(:owner_two) { create(:user, :owner) }
  let(:house_one) { create(:house, :with_seasons, owner: owner_one) }
  let(:house_two) { create(:house, :with_seasons, owner: owner_two) }
  let(:date_start) { current_date + 2.days }
  let(:date_finish) { current_date + 10.days }
  let(:admin) { create(:user, :admin) }
  context 'when user is admin' do
    # TODO: rewrite to macros


    it "shows bookings with status not canceled" do
      sign_in admin
      create(:booking, house: house_one, start: date_start, finish: date_finish, status: "pending")
      visit "/bookings?from=#{current_date}&to=#{current_date + 2.years}"
      # Count by rows in table: 1 record produce 2 rows and 1 extra from table header
      expect(page).to have_selector('table tr', count: 3)
    end

    it "shows bookings with status canceled" do
      sign_in admin
      create(:booking, house: house_one, start: date_start, finish: date_finish, status: "canceled")
      visit "/bookings/canceled?from=#{current_date}&to=#{current_date + 2.years}"
      # Count by rows in table: 1 record produce 2 rows and 1 extra from table header
      expect(page).to have_selector('table tr', count: 3)
    end

    it "shows pending on dashboard view" do
      sign_in admin
      create(:booking, house: house_one, start: date_start, finish: date_finish, status: "pending")
      create(:booking, house: house_two, start: date_start, finish: date_finish, status: "pending")
      visit dashboard_path
      expect(page).to have_selector('div.pending_booking', count: 2)
    end
  end

  context 'user is owner' do

    # Bookings for owner_one
    let!(:booking_owner_one_1) do
      create(:booking, house: house_one, start: date_start, finish: date_finish, status: "pending")
    end
    let!(:booking_owner_one_2) do
      create(:booking, house: house_one, start: date_start + 1.month, finish: date_finish + 1.month, status: "pending")
    end
    # Bookings for owner_two
    let!(:booking_owner_two_1) do
      create(:booking, house: house_two, start: date_start, finish: date_finish, status: "pending")
    end
    let!(:booking_owner_two_2) do
      create(:booking, house: house_two, start: date_start + 1.month, finish: date_finish + 1.month, status: "pending")
    end

    it "shows only own bookings" do
      sign_in owner_one
      visit "/owner/bookings?from=#{current_date}&to=#{current_date + 2.years}"
      expect(page).to have_selector('table tr', minimum: 10) # just to fail and see screenshot
    end
  end
end
