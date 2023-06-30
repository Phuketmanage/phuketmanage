require 'rails_helper'

describe 'House' do
  let(:admin) { create(:user, :admin)}
  let(:manager) {create(:user, :manager)}

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

end