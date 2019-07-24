require 'test_helper'

class JobTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
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
    assert_difference('JobType.count') do
      post job_types_url, params: { job_type: { name: @job_type.name } }
    end

    assert_redirected_to job_type_url(JobType.last)
  end

  test "should show job_type" do
    get job_type_url(@job_type)
    assert_response :success
  end

  test "should get edit" do
    get edit_job_type_url(@job_type)
    assert_response :success
  end

  test "should update job_type" do
    patch job_type_url(@job_type), params: { job_type: { name: @job_type.name } }
    assert_redirected_to job_type_url(@job_type)
  end

  test "should destroy job_type" do
    assert_difference('JobType.count', -1) do
      delete job_type_url(@job_type)
    end

    assert_redirected_to job_types_url
  end
end
