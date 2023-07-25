# frozen_string_literal: true

require 'rails_helper'

describe 'Booking' do
  let(:villa) { create(:house_type, :villa) }
  let(:townhouse) { create(:house_type, :townhouse) }
  let(:admin) { create(:user, :admin) }
  let(:owner1) { create(:user, :owner) }
  let(:owner2) { create(:user, :owner) }
  let(:house) { create(:house, type: villa, owner: owner1) }
  let(:house2) { create(:house, type: townhouse, owner: owner2) }

  date_start = (DateTime.now + 1.year).strftime("%Y-%m-%d")
  date_finish = (DateTime.now + 1.year + 10.days).strftime("%Y-%m-%d")

  it "shows bookings with status not canceled" do
    sign_in admin
    create(:booking, house:, start: date_start, finish: date_finish, status: "pending")
    visit "/bookings?from=#{(DateTime.now - 1.year).strftime('%Y-%m-%d')}&to=#{(DateTime.now + 2.years).strftime('%Y-%m-%d')}"
    # Count by rows in table: 1 record produce 2 rows and 1 extra from table header
    expect(page).to have_selector('table tr', minimum: 3)
  end

  it "shows bookings with status canceled" do
    sign_in admin
    create(:booking, house:, start: date_start, finish: date_finish, status: "canceled")
    visit "/bookings/canceled"
    # Count by rows in table: 1 record produce 2 rows and 1 extra from table header
    expect(page).to have_selector('table tr', minimum: 3)
  end

  it "shows pending on dashboard view" do
    sign_in admin
    create(:booking, house:, start: date_start, finish: date_finish, status: "pending")
    create(:booking, house: house2, start: date_start, finish: date_finish, status: "pending")
    visit dashboard_path
    expect(page).to have_selector('div.pending_booking', minimum: 2)
  end
end
