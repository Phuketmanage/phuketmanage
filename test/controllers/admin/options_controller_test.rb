require 'test_helper'

class Admin::OptionsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:manager)
    @option = options(:one)
  end

  test "should get index" do
    get options_url
    assert_response :success
  end

  test "should get new" do
    get new_option_url
    assert_response :success
  end

  test "should create option" do
    assert_difference('Option.count') do
      post options_url, params: { option: { title_en: @option.title_en, title_ru: @option.title_ru } }
    end

    assert_redirected_to options_url
  end

  # test "should show option" do
  #   get option_url(@option)
  #   assert_response :success
  # end

  test "should get edit" do
    get edit_option_url(@option)
    assert_response :success
  end

  test "should update option" do
    patch option_url(@option), params: { option: { title_en: @option.title_en, title_ru: @option.title_ru } }
    assert_redirected_to options_url
  end

  test "should destroy option" do
    assert_difference('Option.count', -1) do
      delete option_url(@option)
    end

    assert_redirected_to options_url
  end
end
