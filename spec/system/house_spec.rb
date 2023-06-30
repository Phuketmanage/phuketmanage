require 'rails_helper'

describe 'House' do
  let(:admin) { create(:user, :admin)}
  let(:manager) {create(:user, :manager)}
  let(:owner) {create(:user, :owner)}
  let(:villa) {create(:house_type, :villa)}

  it "inactive should be accesed by admin" do
    sign_in admin
    visit houses_inactive_path
    expect(page).to have_content 'Inactive Houses'
  end

  it "inactive shouldn't be accesed from manager" do
    sign_in manager
    visit houses_inactive_path
    expect(page).to have_content 'You are not authorized to access this page.'
  end

  it "should have Inactive button for admin" do
    sign_in admin
    visit houses_path
    expect(page).to have_link 'Inactive Houses'
  end

  it "shouldn't have Inactive button for other roles" do
    sign_in manager
    visit houses_path
    expect(page).to have_no_link 'Inactive Houses'
  end

  it "should have Destroy link for admin" do
    sign_in admin
    visit houses_path
    expect(page).to have_link 'Destroy'
  end

  it "shouldn't have Destroy link for other roles" do
    sign_in manager
    visit houses_path
    expect(page).to have_no_link 'Destroy'
  end

  it "should have for rent list" do
    sign_in admin
    create_list(:house, 5, type: villa, owner: owner, balance_closed: false, unavailable: false)
    visit houses_path
    expect(page).to have_selector('.for_rent div.house', minimum: 5)
  end

  it "should have not for rent list" do
    sign_in admin
    create_list(:house, 5, type: villa, owner: owner, balance_closed: false, unavailable: true)
    visit houses_path
    expect(page).to have_selector('.not_for_rent div.house', minimum: 5)
  end

  it "should have inactive list" do
    sign_in admin
    create_list(:house, 5, type: villa, owner: owner, balance_closed: true)
    visit houses_inactive_path
    expect(page).to have_selector('.inactive_houses div.house', minimum: 5)
  end
end