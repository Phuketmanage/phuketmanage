# frozen_string_literal: true

require 'rails_helper'

describe 'Checkbox hiding unavaliable houses' do
  let(:admin) { create(:user, :admin) }
  let(:manager) { create(:user, :manager) }
  let(:accounting) { create(:user, :accounting) }
  let(:owner) { create(:user, :owner) }
  let(:house) { create(:house, :with_seasons, owner:) }
  let!(:type) { create(:house_type, :villa) }
  let!(:location) { create(:location) }
  let!(:booking) do
    create(:booking, :pending, house:, start: Date.current, finish: Date.current+ 1.year)
  end
  let(:period_from) { 5.days.from_now.to_date.to_fs }
  let(:period_to) { 10.days.from_now.to_date.to_fs }
  let(:search_path) { "/search?search%5Bperiod%5D=#{period_from}+to+#{period_to}&commit=Search" }

  it "hides checkbox for unauthorized user" do
    visit "/"
    expect(page).not_to have_field('checkboxHideUnavailable')
    visit search_path
    expect(page).not_to have_field('checkboxHideUnavailable')
  end

  it "hides checkbox on main page for admin" do
    sign_in admin
    visit "/"
    expect(page).not_to have_field('checkboxHideUnavailable', checked: false)
  end

  it "shows checkbox on search results for admin" do
    sign_in admin
    visit search_path
    expect(page).to have_field('checkboxHideUnavailable')
  end

  it "shows checkbox for manager" do
    sign_in manager
    visit search_path
    expect(page).to have_field('checkboxHideUnavailable')
  end

  it "shows checkbox for accounting" do
    sign_in manager
    visit search_path
    expect(page).to have_field('checkboxHideUnavailable')
  end

  it "hides unavailable houses", js: true do
    sign_in admin
    create_list(:house, 2, :with_seasons)
    visit search_path
    expect(page).to have_selector('div.col.mb-2', count: 3, visible: true)
    expect(page).to have_selector('span.badge.badge-danger', count: 1, visible: true)
    # Hide unavailable houses
    page.check('checkboxHideUnavailable')
    expect(page).to have_selector('div.col.mb-2', count: 2, visible: true)
    expect(page).not_to have_selector('span.badge.badge-danger', count: 1, visible: true)
    # Return them back
    page.uncheck('checkboxHideUnavailable')
    expect(page).to have_selector('div.col.mb-2', count: 3, visible: true)
    expect(page).to have_selector('span.badge.badge-danger', count: 1, visible: true)
  end
end
