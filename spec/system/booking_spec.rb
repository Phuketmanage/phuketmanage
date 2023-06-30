require 'rails_helper'

describe 'Booking' do
  let(:villa) { create(:house_type, :villa) }
  let(:admin) { create(:user, :admin) }
  let(:owner) { create(:user, :owner) }
  let(:house) { create(:house, type: villa, owner: owner) }

  it "should show bookings with status not canceled" do
    sign_in admin
    date_start = (DateTime.now + 1.year).strftime("%Y-%m-%d")
    date_finish = (DateTime.now + 1.year + 10.days).strftime("%Y-%m-%d")
    create(:booking, house: house, start: date_start, finish: date_finish, status: "pending")
    visit "/bookings?from=#{(DateTime.now - 1.year).strftime("%Y-%m-%d")}&to=#{(DateTime.now + 2.years).strftime("%Y-%m-%d")}"
    # Count by rows in table: 1 record produce 2 rows and 1 extra from table header
    expect(page).to have_selector('table tr', minimum: 3)
  end

  it "should show bookings with status canceled" do
    sign_in admin
    date_start = (DateTime.now + 1.year).strftime("%Y-%m-%d")
    date_finish = (DateTime.now + 1.year + 10.days).strftime("%Y-%m-%d")
    create(:booking, house: house, start: date_start, finish: date_finish, status: "canceled")
    visit "/bookings/canceled"
    # Count by rows in table: 1 record produce 2 rows and 1 extra from table header
    expect(page).to have_selector('table tr', minimum: 3)
  end
end