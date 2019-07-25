require 'test_helper'

class JobTypesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:admin)
    @job_type = job_types(:one)
  end

  test "should get index" do
    get job_types_url
    assert_response :success
  end

  test "should get new" do
    get new_job_type_url
    assert_response :success
  end

  test "should create job_type" do
    new_name = 'test'
    assert_difference('JobType.count') do
      post job_types_url, params: { job_type: { name: new_name } }
    end

    assert_redirected_to job_types_url
  end

  test "should get edit" do
    get edit_job_type_url(@job_type)
    assert_response :success
  end

  test "should update job_type" do
    patch job_type_path(@job_type), params: { job_type: { name: @job_type.name } }
    assert_redirected_to job_types_url
  end

  test "should destroy job_type" do
    assert_difference('JobType.count', -1) do
      delete job_type_url(@job_type)
    end

    assert_redirected_to job_types_url
  end
end
