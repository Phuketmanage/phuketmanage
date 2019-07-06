require "application_system_test_case"

class HouseTypesTest < ApplicationSystemTestCase
  setup do
    @house_type = house_types(:one)
  end

  test "visiting the index" do
    visit house_types_url
    assert_selector "h1", text: "House Types"
  end

  test "creating a House type" do
    visit house_types_url
    click_on "New House Type"

    fill_in "Name en", with: @house_type.name_en
    fill_in "Name ru", with: @house_type.name_ru
    click_on "Create House type"

    assert_text "House type was successfully created"
    click_on "Back"
  end

  test "updating a House type" do
    visit house_types_url
    click_on "Edit", match: :first

    fill_in "Name en", with: @house_type.name_en
    fill_in "Name ru", with: @house_type.name_ru
    click_on "Update House type"

    assert_text "House type was successfully updated"
    click_on "Back"
  end

  test "destroying a House type" do
    visit house_types_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "House type was successfully destroyed"
  end
end
