require 'test_helper'

class TransactionFilesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:admin)
  end

  test "should destroy transaction file" do
    file = transaction_files(:one)
    assert_difference('TransactionFile.count', -1) do
      delete transaction_file_path(id: file.id), xhr: true
    end
  end

end
