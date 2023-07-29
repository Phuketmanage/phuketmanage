# frozen_string_literal: true

require 'rails_helper'

describe 'Flatpickr', freeze: '2023-02-01', js: true do
  let(:house) { create(:house) }
  let(:current_date) { '2023-02-01'.to_date }
  let(:booking) do
    create(:booking, house:, start: current_date + 5.days, finish: current_date + 11.days, status: "pending") # Booked from Mon 6 Febrary 2023 to Sun 12 Febrary 2023
  end
  let(:enable_dtnb) { create(:setting, :dtnb) }

  describe 'when clicking date field on main page' do
    context 'when min_days_before_check_in not set' do
      before do
        visit '/'
        find(:css, '.form-control').click
      end

      it "shows calendar" do
        expect(page).to have_css('div.flatpickr-calendar', visible: true)
      end

      it "has monday as first day of week" do
        weekday_container = page.find('div.flatpickr-weekdaycontainer', visible: true)
        weekdays_text = weekday_container.text.split
        index = weekdays_text.index('Mon')
        expect(index).to eq 0
      end

      it "the dates before today are disabled" do
        expect(page).to have_selector('span.flatpickr-day.flatpickr-disabled', visible: true, exact_text: '31')
      end

      it "today is proper set" do
        expect(page).to have_selector('span.flatpickr-day.today', visible: true, exact_text: '1')
      end

      it "today is not avaliable" do
        today = page.find('span.flatpickr-day.today', visible: true, exact_text: '1')
        expect(today).to match_css('span.flatpickr-disabled')
      end

      it "tomorrow is avaliable" do
        expect(page).not_to have_selector('span.flatpickr-day.flatpickr-disabled', visible: true, exact_text: '2')
      end
    end

    context 'when 2 min_days_before_check_in are set' do
      before do
        create(:setting, :min_days_before_check_in)
        visit '/'
        find(:css, '.form-control').click
      end

      it "today is not avaliable" do
        today = page.find('span.flatpickr-day.today', visible: true, exact_text: '1')
        expect(today).to match_css('span.flatpickr-disabled')
      end

      it "+1 day is not avaliable" do
        expect(page).to have_selector('span.flatpickr-day.flatpickr-disabled', visible: true, exact_text: '2')
      end

      it "+2 days is not avaliable" do
        expect(page).to have_selector('span.flatpickr-day.flatpickr-disabled', visible: true, exact_text: '3')
      end

      it "+3 days is avaliable" do
        expect(page).not_to have_selector('span.flatpickr-day.flatpickr-disabled', visible: true, exact_text: '4')
      end
    end
  end

  describe 'when clicking date field on house page' do
    context 'when min_days_before_check_in not set' do
      before do
        booking
        visit house_path(house.number)
        find(:css, '.form-control').click
      end

      it "shows calendar" do
        expect(page).to have_css('div.flatpickr-calendar', visible: true)
      end

      it "has monday as first day of week" do
        weekday_container = page.find('div.flatpickr-weekdaycontainer', visible: true)
        weekdays_text = weekday_container.text.split
        index = weekdays_text.index('Mon')
        expect(index).to eq 0
      end

      it "the dates before today are disabled" do
        expect(page).to have_selector('span.flatpickr-day.flatpickr-disabled', visible: true, exact_text: '31')
      end

      it "today is proper set" do
        expect(page).to have_selector('span.flatpickr-day.today', visible: true, exact_text: '1')
      end

      it "today is not avaliable" do
        today = page.find('span.flatpickr-day.today', visible: true, exact_text: '1')
        expect(today).to match_css('span.flatpickr-disabled')
      end

      it "tomorrow is avaliable" do
        expect(page).not_to have_selector('span.flatpickr-day.flatpickr-disabled', visible: true, exact_text: '2')
      end

      it "the day before booking is avaliable" do
        day = page.find('.dayContainer').find('span.flatpickr-day:not(.nextMonthDay)', visible: true, exact_text: '5')
        expect(day).not_to match_css('span.flatpickr-disabled')
      end

      it "the booked dates are disabled" do
        expect(page).to have_selector('span.flatpickr-day.flatpickr-disabled', visible: true, exact_text: '6')
        expect(page).to have_selector('span.flatpickr-day.flatpickr-disabled', visible: true, exact_text: '7')
        expect(page).to have_selector('span.flatpickr-day.flatpickr-disabled', visible: true, exact_text: '8')
        expect(page).to have_selector('span.flatpickr-day.flatpickr-disabled', visible: true, exact_text: '9')
        expect(page).to have_selector('span.flatpickr-day.flatpickr-disabled', visible: true, exact_text: '10')
        expect(page).to have_selector('span.flatpickr-day.flatpickr-disabled', visible: true, exact_text: '11')
        expect(page).to have_selector('span.flatpickr-day.flatpickr-disabled', visible: true, exact_text: '12')
      end

      it "the day after booking is avaliable" do
        day = page.find('.dayContainer').find('span.flatpickr-day:not(.nextMonthDay)', visible: true, exact_text: '13')
        expect(day).not_to match_css('span.flatpickr-disabled')
      end
    end

    context 'when 2 min_days_before_check_in are set' do
      before do
        create(:setting, :min_days_before_check_in)
        visit '/'
        find(:css, '.form-control').click
      end

      it "today is not avaliable" do
        today = page.find('span.flatpickr-day.today', visible: true, exact_text: '1')
        expect(today).to match_css('span.flatpickr-disabled')
      end

      it "+1 day is not avaliable" do
        expect(page).to have_selector('span.flatpickr-day.flatpickr-disabled', visible: true, exact_text: '2')
      end

      it "+2 days is not avaliable" do
        expect(page).to have_selector('span.flatpickr-day.flatpickr-disabled', visible: true, exact_text: '3')
      end

      it "+3 days is avaliable" do
        expect(page).not_to have_selector('span.flatpickr-day.flatpickr-disabled', visible: true, exact_text: '4')
      end
    end

    context "when dtnb is enabled" do
      before do
        enable_dtnb
        booking
        visit house_path(house.number)
        find(:css, '.form-control').click
      end

      it "has dtnb setting enabled" do
        setting = Setting.find_by(var: "dtnb")
        expect(setting.value).to eq "1"
      end

      it "shows calendar" do
        expect(page).to have_css('div.flatpickr-calendar', visible: true)
      end

      it "the dates before today are disabled" do
        expect(page).to have_selector('span.flatpickr-day.flatpickr-disabled', visible: true, exact_text: '31')
      end

      it "today is proper set" do
        expect(page).to have_selector('span.flatpickr-day.today', visible: true, exact_text: '1')
      end

      it "today is not avaliable" do
        today = page.find('span.flatpickr-day.today', visible: true, exact_text: '1')
        expect(today).to match_css('span.flatpickr-disabled')
      end

      it "tomorrow is avaliable" do
        expect(page).not_to have_selector('span.flatpickr-day.flatpickr-disabled', visible: true, exact_text: '2')
      end

      it "the day before booking - dtnb days setting is avaliable" do
        day = page.find('.dayContainer').find('span.flatpickr-day:not(.nextMonthDay)', visible: true, exact_text: '4')
        expect(day).not_to match_css('span.flatpickr-disabled')
      end

      it "the booked dates + dtnb days around are disabled" do
        expect(page).to have_selector('span.flatpickr-day.flatpickr-disabled', visible: true, exact_text: '5')
        expect(page).to have_selector('span.flatpickr-day.flatpickr-disabled', visible: true, exact_text: '6')
        expect(page).to have_selector('span.flatpickr-day.flatpickr-disabled', visible: true, exact_text: '7')
        expect(page).to have_selector('span.flatpickr-day.flatpickr-disabled', visible: true, exact_text: '8')
        expect(page).to have_selector('span.flatpickr-day.flatpickr-disabled', visible: true, exact_text: '9')
        expect(page).to have_selector('span.flatpickr-day.flatpickr-disabled', visible: true, exact_text: '10')
        expect(page).to have_selector('span.flatpickr-day.flatpickr-disabled', visible: true, exact_text: '11')
        expect(page).to have_selector('span.flatpickr-day.flatpickr-disabled', visible: true, exact_text: '12')
        expect(page).to have_selector('span.flatpickr-day.flatpickr-disabled', visible: true, exact_text: '13')
      end

      it "the (day after booking) + (dtnb days) is avaliable" do
        day = page.find('.dayContainer').find('span.flatpickr-day:not(.nextMonthDay)', visible: true, exact_text: '14')
        expect(day).not_to match_css('span.flatpickr-disabled')
      end
    end
  end
end
