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

end
