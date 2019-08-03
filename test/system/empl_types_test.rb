require "application_system_test_case"

class EmplTypesTest < ApplicationSystemTestCase
  setup do
    @empl_type = empl_types(:one)
  end

  test "visiting the index" do
    visit empl_types_url
    assert_selector "h1", text: "Empl Types"
  end

  test "creating a Empl type" do
    visit empl_types_url
    click_on "New Empl Type"

    fill_in "Name", with: @empl_type.name
    click_on "Create Empl type"

    assert_text "Empl type was successfully created"
    click_on "Back"
  end

  test "updating a Empl type" do
    visit empl_types_url
    click_on "Edit", match: :first

    fill_in "Name", with: @empl_type.name
    click_on "Update Empl type"

    assert_text "Empl type was successfully updated"
    click_on "Back"
  end

  test "destroying a Empl type" do
    visit empl_types_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Empl type was successfully destroyed"
  end
end
