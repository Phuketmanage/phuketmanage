require "application_system_test_case"

class JobTypesTest < ApplicationSystemTestCase
  setup do
    @job_type = job_types(:one)
  end

  test "visiting the index" do
    visit job_types_url
    assert_selector "h1", text: "Job Types"
  end

  test "creating a Job type" do
    visit job_types_url
    click_on "New Job Type"

    fill_in "Name", with: @job_type.name
    click_on "Create Job type"

    assert_text "Job type was successfully created"
    click_on "Back"
  end

  test "updating a Job type" do
    visit job_types_url
    click_on "Edit", match: :first

    fill_in "Name", with: @job_type.name
    click_on "Update Job type"

    assert_text "Job type was successfully updated"
    click_on "Back"
  end

  test "destroying a Job type" do
    visit job_types_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Job type was successfully destroyed"
  end
end
