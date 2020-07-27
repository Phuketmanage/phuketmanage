require "application_system_test_case"

class WaterUsagesTest < ApplicationSystemTestCase
  setup do
    @water_usage = water_usages(:one)
  end

  test "visiting the index" do
    visit water_usages_url
    assert_selector "h1", text: "Water Usages"
  end

  test "creating a Water usage" do
    visit water_usages_url
    click_on "New Water Usage"

    fill_in "Amount", with: @water_usage.amount
    fill_in "Date", with: @water_usage.date
    fill_in "House", with: @water_usage.house_id
    click_on "Create Water usage"

    assert_text "Water usage was successfully created"
    click_on "Back"
  end

  test "updating a Water usage" do
    visit water_usages_url
    click_on "Edit", match: :first

    fill_in "Amount", with: @water_usage.amount
    fill_in "Date", with: @water_usage.date
    fill_in "House", with: @water_usage.house_id
    click_on "Update Water usage"

    assert_text "Water usage was successfully updated"
    click_on "Back"
  end

  test "destroying a Water usage" do
    visit water_usages_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Water usage was successfully destroyed"
  end
end
