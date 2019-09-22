require "application_system_test_case"

class TransactionsTest < ApplicationSystemTestCase
  setup do
    @transaction = transactions(:one)
  end

  test "visiting the index" do
    visit transactions_url
    assert_selector "h1", text: "Transactions"
  end

  test "creating a Transaction" do
    visit transactions_url
    click_on "New Transaction"

    fill_in "Comment en", with: @transaction.comment_en
    fill_in "Comment inner", with: @transaction.comment_inner
    fill_in "Comment ru", with: @transaction.comment_ru
    fill_in "House", with: @transaction.house_id
    fill_in "Ref no", with: @transaction.ref_no
    fill_in "Type", with: @transaction.type_id
    fill_in "User", with: @transaction.user_id
    click_on "Create Transaction"

    assert_text "Transaction was successfully created"
    click_on "Back"
  end

  test "updating a Transaction" do
    visit transactions_url
    click_on "Edit", match: :first

    fill_in "Comment en", with: @transaction.comment_en
    fill_in "Comment inner", with: @transaction.comment_inner
    fill_in "Comment ru", with: @transaction.comment_ru
    fill_in "House", with: @transaction.house_id
    fill_in "Ref no", with: @transaction.ref_no
    fill_in "Type", with: @transaction.type_id
    fill_in "User", with: @transaction.user_id
    click_on "Update Transaction"

    assert_text "Transaction was successfully updated"
    click_on "Back"
  end

  test "destroying a Transaction" do
    visit transactions_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Transaction was successfully destroyed"
  end
end
