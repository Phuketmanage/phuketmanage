require "application_system_test_case"

class PricesTest < ApplicationSystemTestCase
  setup do
    @price = prices(:one)
  end

  test "visiting the index" do
    visit prices_url
    assert_selector "h1", text: "Prices"
  end

  test "creating a Price" do
    visit prices_url
    click_on "New Price"

    fill_in "Amount", with: @price.amount
    fill_in "Duration", with: @price.duration_id
    fill_in "House", with: @price.house_id
    fill_in "Season", with: @price.season_id
    click_on "Create Price"

    assert_text "Price was successfully created"
    click_on "Back"
  end

  test "updating a Price" do
    visit prices_url
    click_on "Edit", match: :first

    fill_in "Amount", with: @price.amount
    fill_in "Duration", with: @price.duration_id
    fill_in "House", with: @price.house_id
    fill_in "Season", with: @price.season_id
    click_on "Update Price"

    assert_text "Price was successfully updated"
    click_on "Back"
  end

  test "destroying a Price" do
    visit prices_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Price was successfully destroyed"
  end
end
