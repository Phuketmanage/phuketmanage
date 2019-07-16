require 'test_helper'

class ConnectionsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:manager)
    @house = House.first
    @source = Source.first
  end

  test "should create connection" do
    assert_difference('Connection.count', 1) do
      post connections_path,  params: {
                                hid: @house.number,
                                connection: {
                                  source_id: @source.id,
                                  link: 'https://site.com/testlink.ical' } }
    end

    assert_redirected_to edit_house_path(@house.number)
  end

  test "should destroy connection" do
    connection = Connection.first
    assert_difference('Connection.count', -1) do
      delete connection_path(connection, hid: connection.house.id)
    end

    assert_redirected_to edit_house_path(connection.house.number)
  end

end
