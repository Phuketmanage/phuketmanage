# frozen_string_literal: true

# rubocop:disable RSpec/MultipleMemoizedHelpers

require 'rails_helper'

describe 'Booking', js: true do
  let(:owner) { create(:user, :owner) }
  # Houses for owner one
  let(:house_one) { create(:house, :with_seasons, owner:) }
  let(:house_two) { create(:house, :with_seasons, owner:) }
  # Dates
  let(:current_date) { Time.zone.today }
  let(:date_start) { current_date + 2.days }
  let(:date_finish) { current_date + 10.days }

  before do
    # Bookings for owner
    create(:booking, house: house_one, start: date_start, finish: date_finish, status: "pending")
    create(:booking, house: house_two, start: date_start, finish: date_finish + 1.week, status: "pending")
    # Other owners bookings
    2.times do
      create(:booking, house: create(:house, :with_seasons), start: date_start, finish: date_finish, status: "pending")
    end
  end

  context 'when user is admin' do
    login_admin

    it "shows bookings with status not canceled" do
      visit "/bookings?from=#{current_date}&to=#{current_date + 2.years}"
      # Count by rows in table: 1 record produce 2 rows and 1 extra from table header
      expect(page).to have_selector('table tr', count: 9)
    end

    it "shows bookings with status canceled" do
      create(:booking, house: house_one, start: date_start, finish: date_finish, status: "canceled")
      visit "/bookings/canceled?from=#{current_date}&to=#{current_date + 2.years}"
      # Count by rows in table: 1 record produce 2 rows and 1 extra from table header
      expect(page).to have_selector('table tr', count: 3)
    end

    it "shows pending on dashboard view" do
      visit dashboard_path
      expect(page).to have_selector('div.pending_booking', count: 4)
    end
  end

  context 'when user is owner' do
    before do
      sign_in owner
      visit "/owner/bookings?from=#{current_date}&to=#{current_date + 2.years}&commit=Show"
    end

    it "shows correct title" do
      expect(page).to have_text("Bookings (2)")
    end

    it "shows table wit two rows" do
      expect(page.all('tr.booking_row').count).to eq(2)
    end

    it "shows ony bookings for his houses" do
      expect(page.text).to include house_one.code, house_two.code
    end
  end
end
