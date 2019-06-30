require "application_system_test_case"

class SeasonsTest < ApplicationSystemTestCase
  setup do
    @season = seasons(:one)
  end

  test "visiting the index" do
    visit seasons_url
    assert_selector "h1", text: "Seasons"
  end

  test "creating a Season" do
    visit seasons_url
    click_on "New Season"

    fill_in "House", with: @season.house_id
    fill_in "Sfd", with: @season.sfd
    fill_in "Sfm", with: @season.sfm
    fill_in "Ssd", with: @season.ssd
    fill_in "Ssm", with: @season.ssm
    click_on "Create Season"

    assert_text "Season was successfully created"
    click_on "Back"
  end

  test "updating a Season" do
    visit seasons_url
    click_on "Edit", match: :first

    fill_in "House", with: @season.house_id
    fill_in "Sfd", with: @season.sfd
    fill_in "Sfm", with: @season.sfm
    fill_in "Ssd", with: @season.ssd
    fill_in "Ssm", with: @season.ssm
    click_on "Update Season"

    assert_text "Season was successfully updated"
    click_on "Back"
  end

  test "destroying a Season" do
    visit seasons_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Season was successfully destroyed"
  end
end
