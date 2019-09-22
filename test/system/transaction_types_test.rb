require "application_system_test_case"

class TransactionTypesTest < ApplicationSystemTestCase
  setup do
    @transaction_type = transaction_types(:one)
  end

  test "visiting the index" do
    visit transaction_types_url
    assert_selector "h1", text: "Transaction Types"
  end

  test "creating a Transaction type" do
    visit transaction_types_url
    click_on "New Transaction Type"

    check "Credit company" if @transaction_type.credit_company
    check "Credit owner" if @transaction_type.credit_owner
    check "Debit company" if @transaction_type.debit_company
    check "Debit owner" if @transaction_type.debit_owner
    fill_in "Name en", with: @transaction_type.name_en
    fill_in "Name ru", with: @transaction_type.name_ru
    click_on "Create Transaction type"

    assert_text "Transaction type was successfully created"
    click_on "Back"
  end

  test "updating a Transaction type" do
    visit transaction_types_url
    click_on "Edit", match: :first

    check "Credit company" if @transaction_type.credit_company
    check "Credit owner" if @transaction_type.credit_owner
    check "Debit company" if @transaction_type.debit_company
    check "Debit owner" if @transaction_type.debit_owner
    fill_in "Name en", with: @transaction_type.name_en
    fill_in "Name ru", with: @transaction_type.name_ru
    click_on "Update Transaction type"

    assert_text "Transaction type was successfully updated"
    click_on "Back"
  end

  test "destroying a Transaction type" do
    visit transaction_types_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Transaction type was successfully destroyed"
  end
end
