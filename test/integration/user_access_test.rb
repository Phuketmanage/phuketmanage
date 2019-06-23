require 'test_helper'

class UserAccessTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test 'forbiden for manager' do
    sign_in users(:adil)
    get new_user_invitation_path
    assert_redirected_to root_path
    follow_redirect!
    assert_select 'p.alert', 'You are not authorized to access this page.'
  end

  test 'forbiden for owners' do
    sign_in users(:andrey)
    get admin_users_path
    assert_redirected_to root_path
    follow_redirect!
    assert_select 'p.alert', 'You are not authorized to access this page.'

    get new_user_invitation_path
    assert_redirected_to root_path
    follow_redirect!
    assert_select 'p.alert', 'You are not authorized to access this page.'

  end

  test 'forbiden for clients' do
    sign_in users(:owner_client)
    get admin_users_path
    assert_redirected_to root_path
    follow_redirect!
    assert_select 'p.alert', 'You are not authorized to access this page.'

    get new_user_invitation_path
    assert_redirected_to root_path
    follow_redirect!
    assert_select 'p.alert', 'You are not authorized to access this page.'

  end


end
