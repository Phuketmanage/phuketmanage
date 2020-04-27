require "application_system_test_case"

class HouseGroupsTest < ApplicationSystemTestCase
  setup do
    @house_group = house_groups(:one)
  end

  test "visiting the index" do
    visit house_groups_url
    assert_selector "h1", text: "House Groups"
  end

  test "creating a House group" do
    visit house_groups_url
    click_on "New House Group"

    fill_in "Name", with: @house_group.name
    click_on "Create House group"

    assert_text "House group was successfully created"
    click_on "Back"
  end

  test "updating a House group" do
    visit house_groups_url
    click_on "Edit", match: :first

    fill_in "Name", with: @house_group.name
    click_on "Update House group"

    assert_text "House group was successfully updated"
    click_on "Back"
  end

  test "destroying a House group" do
    visit house_groups_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "House group was successfully destroyed"
  end
end
