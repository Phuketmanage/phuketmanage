require 'test_helper'

class TransfersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:manager)
    @transfer = transfers(:one)
  end

  test "should get index" do
    get transfers_url
    assert_response :success
  end

  # test "should get new" do
  #   get new_transfer_url, xhr: true
  #   assert_response :success
  #   assert_equal "text/javascript", @response.content_type
  # end

  test "should create transfer" do
    assert_difference('Transfer.count') do
      post transfers_url, params: { transfer: { booking_id: @transfer.booking_id, client: @transfer.client, date: @transfer.date, from: @transfer.from, to: @transfer.to } }, xhr: true
    end

    assert_response :success
  end

  test "should show transfer" do
    get transfer_url(@transfer)
    assert_response :success
  end

  test "should get edit" do
    get edit_transfer_url(@transfer), xhr: true
    assert_response :success
  end

  test "should update transfer" do
    patch transfer_url(@transfer), params: { transfer: { booking_id: @transfer.booking_id, number: @transfer.number } }, xhr: true
    assert_response :success
  end

  test "should destroy transfer" do
    sign_in users(:manager)
    assert_no_difference('Transfer.count', -1) do
      delete transfer_url(@transfer)
    end

    sign_in users(:admin)
    assert_difference('Transfer.count', -1) do
      delete transfer_url(@transfer)
    end

    assert_redirected_to transfers_url
  end
end
