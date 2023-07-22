require 'rails_helper'

describe 'Datepickr', js: true, mock_browser_time: true do
  let(:house) { create(:house) }
  let(:current_date) { DateTime.new(2023, 2, 2).in_time_zone('Bangkok') } # Today is 2 Febrary 2023
  let(:booking) do
    create(:booking, house:, start: current_date + 3.days, finish: current_date + 10.days, status: "pending") # Booked from 5 Febrary 2023 to 12 Febrary 2023
  end

  around do |example|
    Timecop.freeze(current_date) do
      example.run
    end
  end

  context 'on main page when clicking date field' do
    before do
      visit '/'
      find(:id, 'search_period').click
    end
    it "shows calendar" do
      expect(page).to have_css('div.flatpickr-calendar', visible: true)
    end

    it "the dates before today are disabled" do
      expect(page).to have_selector('span.flatpickr-day.flatpickr-disabled', visible: true, text: '1')
    end
    it "today date is avaliable" do
      expect(page).to have_selector('span.flatpickr-day.today', visible: true, text: '2')
      today = page.find('span.flatpickr-day.today', visible: true, text: '2')
      expect(today).not_to match_css('span.flatpickr-disabled')
    end
  end
  context 'house page' do
    before do
      booking
      visit house_path(house.number)
      find(:id, 'period').click
    end
    it "shows calendar" do
      expect(page).to have_css('div.flatpickr-calendar', visible: true)
    end
    it "the dates before today are disabled" do
      expect(page).to have_selector('span.flatpickr-day.flatpickr-disabled', visible: true, text: '1')
    end
    it "today date is avaliable" do
      expect(page).to have_selector('span.flatpickr-day.today', visible: true, text: '2')
      today = page.find('span.flatpickr-day.today', visible: true, text: '2')
      expect(today).not_to match_css('span.flatpickr-disabled')
    end
    it "the booked dates are disabled" do
      expect(page).to have_selector('span.flatpickr-day.flatpickr-disabled', visible: true, text: '5')
      expect(page).to have_selector('span.flatpickr-day.flatpickr-disabled', visible: true, text: '6')
      expect(page).to have_selector('span.flatpickr-day.flatpickr-disabled', visible: true, text: '7')
      expect(page).to have_selector('span.flatpickr-day.flatpickr-disabled', visible: true, text: '8')
      expect(page).to have_selector('span.flatpickr-day.flatpickr-disabled', visible: true, text: '9')
      expect(page).to have_selector('span.flatpickr-day.flatpickr-disabled', visible: true, text: '10')
      expect(page).to have_selector('span.flatpickr-day.flatpickr-disabled', visible: true, text: '11')
      expect(page).to have_selector('span.flatpickr-day.flatpickr-disabled', visible: true, text: '12')
    end
    it "the day after booking is avaliable" do
      expect(page).to have_selector('span.flatpickr-day', visible: true, text: '13')
      day_after_booking = page.find('span.flatpickr-day', visible: true, text: '13')
      expect(day_after_booking).not_to match_css('span.flatpickr-disabled')
    end
  end
end
