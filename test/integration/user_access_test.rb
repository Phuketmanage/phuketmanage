require 'test_helper'

class UserAccessTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test 'settings' do
    sign_in users(:admin)
    get settings_path
    assert_response :success

    sign_in users(:manager)
    get settings_path
    assert_redirected_to root_path
    follow_redirect!
    assert_select 'div.alert', 'You are not authorized to access this page.'

    sign_in users(:owner)
    get settings_path
    assert_redirected_to root_path
    follow_redirect!
    assert_select 'div.alert', 'You are not authorized to access this page.'

    sign_in users(:tenant)
    get settings_path
    assert_redirected_to root_path
    follow_redirect!
    assert_select 'div.alert', 'You are not authorized to access this page.'

    sign_in users(:owner_tenant)
    get settings_path
    assert_redirected_to root_path
    follow_redirect!
    assert_select 'div.alert', 'You are not authorized to access this page.'
  end

  test 'users' do
    sign_in users(:admin)
    get users_path
    assert_response :success

    sign_in users(:manager)
    get users_path
    assert_response :success

    sign_in users(:owner)
    get users_path
    assert_redirected_to root_path
    follow_redirect!
    assert_select 'div.alert', 'You are not authorized to access this page.'

    sign_in users(:tenant)
    get users_path
    assert_redirected_to root_path
    follow_redirect!
    assert_select 'div.alert', 'You are not authorized to access this page.'

    sign_in users(:owner_tenant)
    get users_path
    assert_redirected_to root_path
    follow_redirect!
    assert_select 'div.alert', 'You are not authorized to access this page.'
  end

  test 'invatations' do
    sign_in users(:admin)
    get new_user_invitation_path
    assert_response :success

    sign_in users(:manager)
    get new_user_invitation_path
    assert_redirected_to root_path
    follow_redirect!
    assert_select 'div.alert', 'You are not authorized to access this page.'

    post user_invitation_path params: {user: {email: 'test10@test.com'}}
    assert_redirected_to root_path
    follow_redirect!
    assert_select 'div.alert', 'You are not authorized to access this page.'

    sign_in users(:owner)
    get new_user_invitation_path
    assert_redirected_to root_path
    follow_redirect!
    assert_select 'div.alert', 'You are not authorized to access this page.'

    post user_invitation_path params: {user: {email: 'test10@test.com'}}
    assert_redirected_to root_path
    follow_redirect!
    assert_select 'div.alert', 'You are not authorized to access this page.'

    sign_in users(:tenant)
    get new_user_invitation_path
    assert_redirected_to root_path
    follow_redirect!
    assert_select 'div.alert', 'You are not authorized to access this page.'

    post user_invitation_path params: {user: {email: 'test10@test.com'}}
    assert_redirected_to root_path
    follow_redirect!
    assert_select 'div.alert', 'You are not authorized to access this page.'

    sign_in users(:owner_tenant)
    get new_user_invitation_path
    assert_redirected_to root_path
    follow_redirect!
    assert_select 'div.alert', 'You are not authorized to access this page.'

    post user_invitation_path params: {user: {email: 'test10@test.com'}}
    assert_redirected_to root_path
    follow_redirect!
    assert_select 'div.alert', 'You are not authorized to access this page.'

  end

  test "user can only destroy job which they own" do
    manager = users(:manager)
    admin = users(:admin)
    ability = Ability.new(manager)
    assert ability.can?(:destroy, Job.new(creator: manager))
    assert ability.cannot?(:destroy, Job.new(creator: admin))
  end

  test 'owner can see only his own balance' do
    sign_in users(:owner)
    get balance_front_path
    assert_select 'tr.trsc_row', 2
    assert_select 'td.de_ow_cell', text: '80,000.00', count: 1
    assert_select 'td.cr_ow_cell', text: '2,200.99', count: 1
    assert_select 'td.cr_ow_cell', text: '16,050.00', count: 0 #owner_2
    assert_select 'td.de_ow_cell', text: '38,000.00', count: 0 #owner_2
    assert_select 'td.de_ow_cell', text: '40,000.00', count: 0 #owner_2
    assert_select 'td.cr_ow_cell', text: '5,000.00', count: 0 #company

    sign_in users(:owner_2)
    get balance_front_path
    assert_select 'tr.trsc_row', 3
    assert_select 'td.de_ow_cell', text: '80,000.00', count: 0
    assert_select 'td.cr_ow_cell', text: '2,200.99', count: 0
    assert_select 'td.cr_ow_cell', text: '16,050.00', count: 1 #owner_2
    assert_select 'td.de_ow_cell', text: '38,000.00', count: 1 #owner_2
    assert_select 'td.de_ow_cell', text: '40,000.00', count: 1 #owner_2
    assert_select 'td.cr_ow_cell', text: '5,000.00', count: 0 #company

  end

  test 'transactions aka balance' do
    sign_in users(:manager)
    get transactions_path
    assert_response :success
    @transaction = transactions(:one)
    assert_no_difference('Transaction.count') do
      delete transaction_url(@transaction)
    end
    assert_redirected_to root_path
    follow_redirect!
    assert_select 'div.alert', 'You are not authorized to access this page.'

    sign_in users(:owner)
    get transactions_path
    assert_redirected_to root_path
    follow_redirect!
    assert_select 'div.alert', 'You are not authorized to access this page.'

    sign_in users(:tenant)
    get transactions_path
    assert_redirected_to root_path
    follow_redirect!
    assert_select 'div.alert', 'You are not authorized to access this page.'

    sign_in users(:owner_tenant)
    get transactions_path
    assert_redirected_to root_path
    follow_redirect!
    assert_select 'div.alert', 'You are not authorized to access this page.'



  end

end
