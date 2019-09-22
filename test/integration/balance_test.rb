require 'test_helper'

class BalanceAmountTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:admin)
    @owner = users(:owner)
    @house = houses(:villa_1)
  end

  test "transaction allocation" do
    # Rental
    type = TransactionType.find_by(name_en: 'Rental')
    post transactions_path, params: {
                              transaction: {
                                date: Time.now.to_date,
                                type_id: type.id,
                                house_id: @house.id,
                                de_ow: 100000,
                                de_co: 20000,
                                comment_en: 'Rental'} }
    # assert_match 'test', response.body
    t = Transaction.last
    assert_equal 1, t.balance_outs.count
    assert_equal 100000, t.balance_outs.sum(:debit)
    assert_equal 20000, t.balance_outs.sum(:credit)
    assert_equal 1, t.balances.count
    assert_equal 20000, t.balances.sum(:debit)
    assert_equal 0, t.balances.sum(:credit)
    assert_response :redirect
    follow_redirect!
    assert_response :success
    get transactions_path, params: { commit: 'Company view'}
    assert_response :success
    assert_select "tr#trsc_#{t.id}_row td.de_co_cell", '20,000.00'
    assert_select "tr#trsc_#{t.id}_row td.cr_co_cell", ''
    assert_select "tr#trsc_#{t.id}_row td.de_ow_cell", '100,000.00'
    assert_select "tr#trsc_#{t.id}_row td.cr_ow_cell", '20,000.00'
    get transactions_path, params: { user_id: @owner.id, commit: 'Owner view'}
    assert_response :success
    assert_select "tr#trsc_#{t.id}_row td.de_ow_cell", '80,000.00'
    assert_select "tr#trsc_#{t.id}_row td.cr_ow_cell", ''
    get transactions_path, params: { user_id: @owner.id, commit: 'Accounting view'}
    assert_response :success
    assert_select "tr#trsc_#{t.id}_row td.de_ow_cell", '100,000.00'
    assert_select "tr#trsc_#{t.id}_row td.cr_ow_cell", ''
    assert_select "tr#trsc_#{t.id}_iv_row td.iv_price_cell", '20,000.00' #Invoice

    # Maintenance
    type = TransactionType.find_by(name_en: 'Maintenance')
    post transactions_path, params: {
                              transaction: {
                                date: Time.now.to_date,
                                type_id: type.id,
                                house_id: @house.id,
                                cr_ow: 15000,
                                comment_en: 'Maintenance'} }
    # assert_match 'test', response.body
    t = Transaction.last
    assert_equal 1, t.balance_outs.count
    assert_equal 0, t.balance_outs.sum(:debit)
    assert_equal 15000, t.balance_outs.sum(:credit)
    assert_equal 1, t.balances.count
    assert_equal 15000, t.balances.sum(:debit)
    assert_equal 0, t.balances.sum(:credit)
    assert_response :redirect
    follow_redirect!
    assert_response :success
    get transactions_path, params: { commit: 'Company view'}
    assert_response :success
    assert_select "tr#trsc_#{t.id}_row td.de_co_cell", '15,000.00'
    assert_select "tr#trsc_#{t.id}_row td.cr_co_cell", ''
    assert_select "tr#trsc_#{t.id}_row td.de_ow_cell", ''
    assert_select "tr#trsc_#{t.id}_row td.cr_ow_cell", '15,000.00'
    get transactions_path, params: { user_id: @owner.id, commit: 'Owner view'}
    assert_response :success
    assert_select "tr#trsc_#{t.id}_row td.de_ow_cell", ''
    assert_select "tr#trsc_#{t.id}_row td.cr_ow_cell", '15,000.00'
    get transactions_path, params: { user_id: @owner.id, commit: 'Accounting view'}
    assert_response :success
    assert_select "tr#trsc_#{t.id}_row", count: 0
    assert_select "tr#trsc_#{t.id}_iv_row td.iv_price_cell", '15,000.00' #Invoice

    # Laundry
    type = TransactionType.find_by(name_en: 'Laundry')
    post transactions_path, params: {
                              transaction: {
                                date: Time.now.to_date,
                                type_id: type.id,
                                house_id: @house.id,
                                cr_ow: 300,
                                comment_en: 'Laundry'} }
    # assert_match 'test', response.body
    t = Transaction.last
    assert_equal 1, t.balance_outs.count
    assert_equal 0, t.balance_outs.sum(:debit)
    assert_equal 300, t.balance_outs.sum(:credit)
    assert_equal 1, t.balances.count
    assert_equal 300, t.balances.sum(:debit)
    assert_equal 0, t.balances.sum(:credit)
    assert_response :redirect
    follow_redirect!
    assert_response :success
    get transactions_path, params: { commit: 'Company view'}
    assert_response :success
    assert_select "tr#trsc_#{t.id}_row td.de_co_cell", '300.00'
    assert_select "tr#trsc_#{t.id}_row td.cr_co_cell", ''
    assert_select "tr#trsc_#{t.id}_row td.de_ow_cell", ''
    assert_select "tr#trsc_#{t.id}_row td.cr_ow_cell", '300.00'
    get transactions_path, params: { user_id: @owner.id, commit: 'Owner view'}
    assert_response :success
    assert_select "tr#trsc_#{t.id}_row td.de_ow_cell", ''
    assert_select "tr#trsc_#{t.id}_row td.cr_ow_cell", '300.00'
    get transactions_path, params: { user_id: @owner.id, commit: 'Accounting view'}
    assert_response :success
    assert_select "tr#trsc_#{t.id}_row", count: 0
    assert_select "tr#trsc_#{t.id}_iv_row td.iv_price_cell", '300.00' #Invoice

    # Top up
    type = TransactionType.find_by(name_en: 'Top up')
    post transactions_path, params: {
                              transaction: {
                                date: Time.now.to_date,
                                type_id: type.id,
                                house_id: @house.id,
                                de_ow: 50000,
                                comment_en: 'Top up'} }
    # assert_match 'test', response.body
    t = Transaction.last
    assert_equal 1, t.balance_outs.count
    assert_equal 50000, t.balance_outs.sum(:debit)
    assert_equal 0, t.balance_outs.sum(:credit)
    assert_equal 0, t.balances.count
    assert_equal 0, t.balances.sum(:debit)
    assert_equal 0, t.balances.sum(:credit)
    assert_response :redirect
    follow_redirect!
    assert_response :success
    get transactions_path, params: { commit: 'Company view'}
    assert_response :success
    assert_select "tr#trsc_#{t.id}_row td.de_co_cell", ''
    assert_select "tr#trsc_#{t.id}_row td.cr_co_cell", ''
    assert_select "tr#trsc_#{t.id}_row td.de_ow_cell", '50,000.00'
    assert_select "tr#trsc_#{t.id}_row td.cr_ow_cell", ''
    get transactions_path, params: { user_id: @owner.id, commit: 'Owner view'}
    assert_response :success
    assert_select "tr#trsc_#{t.id}_row td.de_ow_cell", '50,000.00'
    assert_select "tr#trsc_#{t.id}_row td.cr_ow_cell", ''
    get transactions_path, params: { user_id: @owner.id, commit: 'Accounting view'}
    assert_response :success
    assert_select "tr#trsc_#{t.id}_row td.de_ow_cell", '50,000.00'
    assert_select "tr#trsc_#{t.id}_row td.cr_ow_cell", ''
    assert_select "tr#trsc_#{t.id}_iv_row", count: 0 #Invoice

    # Utilities received
    type = TransactionType.find_by(name_en: 'Utilities received')
    post transactions_path, params: {
                              transaction: {
                                date: Time.now.to_date,
                                type_id: type.id,
                                house_id: @house.id,
                                de_ow: 5500,
                                comment_en: 'Utilities received'} }
    # assert_match 'test', response.body
    t = Transaction.last
    assert_equal 1, t.balance_outs.count
    assert_equal 5500, t.balance_outs.sum(:debit)
    assert_equal 0, t.balance_outs.sum(:credit)
    assert_equal 0, t.balances.count
    assert_equal 0, t.balances.sum(:debit)
    assert_equal 0, t.balances.sum(:credit)
    assert_response :redirect
    follow_redirect!
    assert_response :success
    get transactions_path, params: { commit: 'Company view'}
    assert_response :success
    assert_select "tr#trsc_#{t.id}_row td.de_co_cell", ''
    assert_select "tr#trsc_#{t.id}_row td.cr_co_cell", ''
    assert_select "tr#trsc_#{t.id}_row td.de_ow_cell", '5,500.00'
    assert_select "tr#trsc_#{t.id}_row td.cr_ow_cell", ''
    get transactions_path, params: { user_id: @owner.id, commit: 'Owner view'}
    assert_response :success
    assert_select "tr#trsc_#{t.id}_row td.de_ow_cell", '5,500.00'
    assert_select "tr#trsc_#{t.id}_row td.cr_ow_cell", ''
    get transactions_path, params: { user_id: @owner.id, commit: 'Accounting view'}
    assert_response :success
    assert_select "tr#trsc_#{t.id}_row td.de_ow_cell", '5,500.00'
    assert_select "tr#trsc_#{t.id}_row td.cr_ow_cell", ''
    assert_select "tr#trsc_#{t.id}_iv_row", count: 0 #Invoice

    # Repair
    type = TransactionType.find_by(name_en: 'Repair')
    post transactions_path, params: {
                              transaction: {
                                date: Time.now.to_date,
                                type_id: type.id,
                                house_id: @house.id,
                                cr_ow: 500,
                                cr_co: 1000,
                                de_co: 700,
                                comment_en: 'Repair'} }
    # assert_match 'test', response.body
    t = Transaction.last
    assert_equal 1, t.balance_outs.count
    assert_equal 0, t.balance_outs.sum(:debit)
    assert_equal 2200, t.balance_outs.sum(:credit)
    assert_equal 1, t.balances.count
    assert_equal 1700, t.balances.sum(:debit)
    assert_equal 1000, t.balances.sum(:credit)
    assert_response :redirect
    follow_redirect!
    assert_response :success
    get transactions_path, params: { commit: 'Company view'}
    assert_response :success
    assert_select "tr#trsc_#{t.id}_row td.de_co_cell", '1,700.00'
    assert_select "tr#trsc_#{t.id}_row td.cr_co_cell", '1,000.00'
    assert_select "tr#trsc_#{t.id}_row td.de_ow_cell", ''
    assert_select "tr#trsc_#{t.id}_row td.cr_ow_cell", '2,200.00'
    get transactions_path, params: { user_id: @owner.id, commit: 'Owner view'}
    assert_response :success
    assert_select "tr#trsc_#{t.id}_row td.de_ow_cell", ''
    assert_select "tr#trsc_#{t.id}_row td.cr_ow_cell", '2,200.00'
    get transactions_path, params: { user_id: @owner.id, commit: 'Accounting view'}
    assert_response :success
    assert_select "tr#trsc_#{t.id}_row td.de_ow_cell", ''
    assert_select "tr#trsc_#{t.id}_row td.cr_ow_cell", '500.00'
    assert_select "tr#trsc_#{t.id}_iv_row td.iv_price_cell", '1,700.00' #Invoice

    # Purchases
    type = TransactionType.find_by(name_en: 'Purchases')
    post transactions_path, params: {
                              transaction: {
                                date: Time.now.to_date,
                                type_id: type.id,
                                house_id: @house.id,
                                cr_ow: 7500,
                                de_co: 1500,
                                comment_en: 'Purchases'} }
    # assert_match 'test', response.body
    t = Transaction.last
    assert_equal 1, t.balance_outs.count
    assert_equal 0, t.balance_outs.sum(:debit)
    assert_equal 9000, t.balance_outs.sum(:credit)
    assert_equal 1, t.balances.count
    assert_equal 1500, t.balances.sum(:debit)
    assert_equal 0, t.balances.sum(:credit)
    assert_response :redirect
    follow_redirect!
    assert_response :success
    get transactions_path, params: { commit: 'Company view'}
    assert_response :success
    assert_select "tr#trsc_#{t.id}_row td.de_co_cell", '1,500.00'
    assert_select "tr#trsc_#{t.id}_row td.cr_co_cell", ''
    assert_select "tr#trsc_#{t.id}_row td.de_ow_cell", ''
    assert_select "tr#trsc_#{t.id}_row td.cr_ow_cell", '9,000.00'
    get transactions_path, params: { user_id: @owner.id, commit: 'Owner view'}
    assert_response :success
    assert_select "tr#trsc_#{t.id}_row td.de_ow_cell", ''
    assert_select "tr#trsc_#{t.id}_row td.cr_ow_cell", '9,000.00'
    get transactions_path, params: { user_id: @owner.id, commit: 'Accounting view'}
    assert_response :success
    assert_select "tr#trsc_#{t.id}_row td.de_ow_cell", ''
    assert_select "tr#trsc_#{t.id}_row td.cr_ow_cell", '7,500.00'
    assert_select "tr#trsc_#{t.id}_iv_row td.iv_price_cell", '1,500.00' #Invoice

    # ['Utilities', 'Pest control', 'Insurance', 'Salary', 'Gasoline', 'Office', 'Suppliers', 'Equipment']
    type = TransactionType.find_by(name_en: 'Utilities')
    post transactions_path, params: {
                              transaction: {
                                date: Time.now.to_date,
                                type_id: type.id,
                                house_id: @house.id,
                                cr_ow: 3500,
                                comment_en: 'Electricity 08.2019'} }
    # assert_match 'test', response.body
    t = Transaction.last
    assert_equal 1, t.balance_outs.count
    assert_equal 0, t.balance_outs.sum(:debit)
    assert_equal 3500, t.balance_outs.sum(:credit)
    assert_equal 0, t.balances.count
    assert_equal 0, t.balances.sum(:debit)
    assert_equal 0, t.balances.sum(:credit)
    assert_response :redirect
    follow_redirect!
    assert_response :success
    get transactions_path, params: { commit: 'Company view'}
    assert_response :success
    assert_select "tr#trsc_#{t.id}_row td.de_co_cell", ''
    assert_select "tr#trsc_#{t.id}_row td.cr_co_cell", ''
    assert_select "tr#trsc_#{t.id}_row td.de_ow_cell", ''
    assert_select "tr#trsc_#{t.id}_row td.cr_ow_cell", '3,500.00'
    get transactions_path, params: { user_id: @owner.id, commit: 'Owner view'}
    assert_response :success
    assert_select "tr#trsc_#{t.id}_row td.de_ow_cell", ''
    assert_select "tr#trsc_#{t.id}_row td.cr_ow_cell", '3,500.00'
    get transactions_path, params: { user_id: @owner.id, commit: 'Accounting view'}
    assert_response :success
    assert_select "tr#trsc_#{t.id}_row td.de_ow_cell", ''
    assert_select "tr#trsc_#{t.id}_row td.cr_ow_cell", '3,500.00'
    assert_select "tr#trsc_#{t.id}_iv_row", count: 0 #Invoice

    # Check sums
    get transactions_path, params: { user_id: @owner.id, commit: 'Company view'}
    de_co_sum = Transaction.where(user_id: @owner.id).joins(:balances).sum('balances.debit')
    assert_select "#de_co_sum", "#{de_co_sum}"
    cr_co_sum = Transaction.where(user_id: @owner.id).joins(:balances).sum('balances.credit')
    assert_select "#cr_co_sum", "#{cr_co_sum}"


  end
end
