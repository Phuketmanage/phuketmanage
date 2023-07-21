require 'rails_helper'
describe 'Search' do
  let(:admin) { create(:user, :admin) }
  let(:manager) { create(:user, :manager) }
  let(:accounting) { create(:user, :accounting) }
  let(:owner) { create(:user, :owner) }
  let(:house) { House.find_by(title_en: 'Villa 1') }
  let(:booking) do
    create(:booking, house:, start: DateTime.now, finish: DateTime.now + 1.year, status: "pending")
  end

  context "Hide unavaliable houses" do
    before do
      booking
    end
    it "hides checkbox for unauthorized user" do
      visit "/"
      expect(page).not_to have_field('checkboxHideUnavailable')
    end
    it "shows checkbox for admin" do
      sign_in admin
      visit "/"
      expect(page).to have_field('checkboxHideUnavailable', checked: false)
    end
    it "shows checkbox for manager" do
      sign_in manager
      visit "/"
      expect(page).to have_field('checkboxHideUnavailable', checked: false)
    end
    it "shows checkbox for accounting" do
      sign_in manager
      visit "/"
      expect(page).to have_field('checkboxHideUnavailable', checked: false)
    end
    it "hides unavaliable houses", js: true do
      sign_in admin
      period_from = Date.today.advance(days: 3).strftime("%Y-%m-%d")
      period_to = Date.today.advance(days: 10).strftime("%Y-%m-%d")
      visit "/search?search%5Bperiod%5D=#{period_from}+to+#{period_to}&commit=Search"
      expect(page).to have_selector('div.col.mb-2', count: 3, visible: true)
      expect(page).to have_selector('span.badge.badge-danger', count: 1, visible: true)
      # Hide unavaliable houses
      page.check('checkboxHideUnavailable')
      expect(page).to have_selector('div.col.mb-2', count: 2, visible: true)
      expect(page).not_to have_selector('span.badge.badge-danger', count: 1, visible: true)
      # Return them back
      page.uncheck('checkboxHideUnavailable')
      expect(page).to have_selector('div.col.mb-2', count: 3, visible: true)
      expect(page).to have_selector('span.badge.badge-danger', count: 1, visible: true)
    end
  end
end
