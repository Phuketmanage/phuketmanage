require 'test_helper'

class TransactionsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:admin)
    @transaction = transactions(:one)
  end

  test "should get index" do
    get transactions_url
    assert_response :success
  end

  test "should get new" do
    get new_transaction_url
    assert_response :success
  end

  test "should create transaction" do
    assert_difference('Transaction.count') do
      post transactions_url,  params: {
                                transaction: {
                                  date: @transaction.date,
                                  comment_en: @transaction.comment_en,
                                  comment_inner: @transaction.comment_inner,
                                  comment_ru: @transaction.comment_ru,
                                  house_id: @transaction.house_id,
                                  ref_no: @transaction.ref_no,
                                  type_id: @transaction.type_id,
                                  user_id: @transaction.user_id } }
    end

    assert_redirected_to transactions_path
  end

  test "should show transaction" do
    get transaction_url(@transaction)
    assert_response :success
  end

  test "should get edit" do
    get edit_transaction_url(@transaction)
    assert_response :success
  end

  test "should update transaction" do
    patch transaction_url(@transaction),  params: {
                                            transaction: {
                                              date: @transaction.date,
                                              comment_en: @transaction.comment_en,
                                              comment_inner: @transaction.comment_inner,
                                              comment_ru: @transaction.comment_ru,
                                              house_id: @transaction.house_id,
                                              ref_no: @transaction.ref_no,
                                              type_id: @transaction.type_id,
                                              user_id: @transaction.user_id } }
    assert_redirected_to transaction_url(@transaction)
  end

  test "should destroy transaction" do
    assert_difference('Transaction.count', -1) do
      delete transaction_url(@transaction)
    end

    assert_redirected_to transactions_url
  end
end
