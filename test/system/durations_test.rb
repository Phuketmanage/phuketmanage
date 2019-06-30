require "application_system_test_case"

class DurationsTest < ApplicationSystemTestCase
  setup do
    @duration = durations(:one)
  end

  test "visiting the index" do
    visit durations_url
    assert_selector "h1", text: "Durations"
  end

  test "creating a Duration" do
    visit durations_url
    click_on "New Duration"

    fill_in "Finish", with: @duration.finish
    fill_in "House", with: @duration.house_id
    fill_in "Start", with: @duration.start
    click_on "Create Duration"

    assert_text "Duration was successfully created"
    click_on "Back"
  end

  test "updating a Duration" do
    visit durations_url
    click_on "Edit", match: :first

    fill_in "Finish", with: @duration.finish
    fill_in "House", with: @duration.house_id
    fill_in "Start", with: @duration.start
    click_on "Update Duration"

    assert_text "Duration was successfully updated"
    click_on "Back"
  end

  test "destroying a Duration" do
    visit durations_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Duration was successfully destroyed"
  end
end
