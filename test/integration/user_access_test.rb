require 'test_helper'

class UserAccessTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers


  test 'users' do
    sign_in users(:admin)
    get admin_users_path
    assert_response :success

    sign_in users(:manager)
    get admin_users_path
    assert_response :success

    sign_in users(:owner)
    get admin_users_path
    assert_redirected_to root_path
    follow_redirect!
    assert_select 'p.alert', 'You are not authorized to access this page.'

    sign_in users(:owner_client)
    get admin_users_path
    assert_redirected_to root_path
    follow_redirect!
    assert_select 'p.alert', 'You are not authorized to access this page.'

  end

  test 'invatations' do
    sign_in users(:admin)
    get new_user_invitation_path
    assert_response :success

    sign_in users(:manager)
    get new_user_invitation_path
    assert_redirected_to root_path
    follow_redirect!
    assert_select 'p.alert', 'You are not authorized to access this page.'

    post user_invitation_path params: {user: {email: 'test10@test.com'}}
    assert_redirected_to root_path
    follow_redirect!
    assert_select 'p.alert', 'You are not authorized to access this page.'

    sign_in users(:owner)
    get new_user_invitation_path
    assert_redirected_to root_path
    follow_redirect!
    assert_select 'p.alert', 'You are not authorized to access this page.'

    post user_invitation_path params: {user: {email: 'test10@test.com'}}
    assert_redirected_to root_path
    follow_redirect!
    assert_select 'p.alert', 'You are not authorized to access this page.'

    sign_in users(:owner_client)
    get new_user_invitation_path
    assert_redirected_to root_path
    follow_redirect!
    assert_select 'p.alert', 'You are not authorized to access this page.'

    post user_invitation_path params: {user: {email: 'test10@test.com'}}
    assert_redirected_to root_path
    follow_redirect!
    assert_select 'p.alert', 'You are not authorized to access this page.'

  end


end
