require 'test_helper'

class JobsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:admin)
    @job = jobs(:one)
  end

  test "should get index" do
    get jobs_url
    assert_response :success
  end

  test "should get new" do
    get new_job_url
    assert_response :success
  end

  test "should create job" do
    new_name = 'test'
    assert_difference('Job.count') do
      post jobs_url, params: { job: { booking_id: @job.booking_id, comment: @job.comment, plan: @job.plan, house_id: @job.house_id, job_type_id: @job.job_type_id, time: @job.time } }
    end

    assert_redirected_to jobs_url
  end

  test "should get edit" do
    get edit_job_url(@job)
    assert_response :success
  end

  test "should update job" do
    patch job_url(@job), params: { job: { booking_id: @job.booking_id, comment: @job.comment, plan: @job.plan, house_id: @job.house_id, job_type_id: @job.job_type_id, time: @job.time } }
    assert_redirected_to job_url(@job)
  end

  test "should destroy job" do
    assert_difference('Job.count', -1) do
      delete job_url(@job)
    end

    assert_redirected_to jobs_url
  end
end
