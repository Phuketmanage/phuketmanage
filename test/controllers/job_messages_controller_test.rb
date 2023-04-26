require 'test_helper'

class JobMessagesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:admin)
    @job = jobs(:two)
  end

  test "should create job message" do
    job = jobs(:two)
    assert_difference('JobMessage.count') do
      post job_messages_url, params: {
        job_message: {
          message: 'Test'
        },
        job_id: @job.id
      }, xhr: true
    end
  end

  test "should destroy job message" do
    job_message = job_messages(:one)
    assert_difference('JobMessage.count', -1) do
      delete job_message_url(id: job_message.id), xhr: true
    end
  end
end
