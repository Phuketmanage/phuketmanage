require 'rails_helper'

describe 'User' do
  let(:admin) { create(:user, :admin)}
  let(:owner_closed) { create(:user, :owner, balance_closed: true)}
  it 'should sign in' do
    visit "/en/users/sign_in"
    fill_in 'Email', with: admin.email
    fill_in 'Password', with: 'qweasd'
    click_button 'Log in'
    expect(page).to have_content 'Signed in successfully.'
  end
  it 'should sign out' do
    sign_in admin
    visit '/en'
    click_link 'Log out'
    expect(page).to have_content 'Signed out successfully.'
  end
  it 'should not sign in when balance closed' do
    visit "/en/users/sign_in"
    fill_in 'Email', with: owner_closed.email
    fill_in 'Password', with: 'qweasd'
    click_button 'Log in'
    expect(page).to have_content 'Your account was closed.'
  end
end