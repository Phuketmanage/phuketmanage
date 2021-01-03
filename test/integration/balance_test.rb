require 'test_helper'

class BalanceAmountTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:admin)
    # @owner = users(:owner)
    @house = houses(:villa_1)
    @owner = @house.owner
    @booking = bookings(:_1)
  end

  test "transaction allocation" do
    # Rental
    type = TransactionType.find_by(name_en: 'Rental')
    post transactions_path, params: {
                              transaction: {
                                date: Time.now.to_date,
                                type_id: type.id,
                                booking_id: @booking.id,
                                de_ow: 100000,
                                de_co: 20000,
                                booking_fully_paid: true,
                                comment_en: 'Rental'} }
    t = Transaction.last
    assert_equal 2, t.balance_outs.count
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
    get transactions_path, params: { view_user_id: @owner.id, commit: 'Owner view'}
    assert_response :success
    assert_select "tr#trsc_#{t.id}_row td.de_ow_cell", '80,000.00'
    assert_select "tr#trsc_#{t.id}_row td.cr_ow_cell", ''
    get transactions_path, params: { view_user_id: @owner.id, commit: 'Accounting view'}
    assert_response :success
    assert_select "tr#trsc_#{t.id}_row td.de_ow_cell", '100,000.00'
    assert_select "tr#trsc_#{t.id}_row td.cr_ow_cell", ''
    get transactions_docs_path, params: {
      type: 'invoice',
      from: Time.now.to_date.beginning_of_month,
      to: Time.now.to_date.end_of_month,
      view_user_id: @owner.id}
    assert_select "tr#trsc_#{t.id}_iv_row td.iv_price_bvat_cell", '18,691.59' #Invoice

    # Maintenance
    type = TransactionType.find_by(name_en: 'Maintenance')
    post transactions_path, params: {
                              transaction: {
                                date: Time.now.to_date,
                                type_id: type.id,
                                house_id: @house.id,
                                de_co: 15000,
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
    get transactions_path, params: { view_user_id: @owner.id, commit: 'Owner view'}
    assert_response :success
    assert_select "tr#trsc_#{t.id}_row td.de_ow_cell", ''
    assert_select "tr#trsc_#{t.id}_row td.cr_ow_cell", '15,000.00'
    get transactions_path, params: { view_user_id: @owner.id, commit: 'Accounting view'}
    assert_response :success
    assert_select "tr#trsc_#{t.id}_row", count: 0
    get transactions_docs_path, params: {
      type: 'invoice',
      from: Time.now.to_date.beginning_of_month,
      to: Time.now.to_date.end_of_month,
      view_user_id: @owner.id}
    assert_select "tr#trsc_#{t.id}_iv_row td.iv_price_bvat_cell", '14,018.69' #Invoice

    # Laundry
    type = TransactionType.find_by(name_en: 'Laundry')
    post transactions_path, params: {
                              transaction: {
                                date: Time.now.to_date,
                                type_id: type.id,
                                house_id: @house.id,
                                de_co: 300,
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
    get transactions_path, params: { view_user_id: @owner.id, commit: 'Owner view'}
    assert_response :success
    assert_select "tr#trsc_#{t.id}_row td.de_ow_cell", ''
    assert_select "tr#trsc_#{t.id}_row td.cr_ow_cell", '300.00'
    get transactions_path, params: { view_user_id: @owner.id, commit: 'Accounting view'}
    assert_response :success
    assert_select "tr#trsc_#{t.id}_row", count: 0
    get transactions_docs_path, params: {
      type: 'invoice',
      from: Time.now.to_date.beginning_of_month,
      to: Time.now.to_date.end_of_month,
      view_user_id: @owner.id}
    assert_select "tr#trsc_#{t.id}_iv_row td.iv_price_bvat_cell", '280.37' #Invoice

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
    get transactions_path, params: { view_user_id: @owner.id, commit: 'Owner view'}
    assert_response :success
    assert_select "tr#trsc_#{t.id}_row td.de_ow_cell", '50,000.00'
    assert_select "tr#trsc_#{t.id}_row td.cr_ow_cell", ''
    get transactions_path, params: { view_user_id: @owner.id, commit: 'Accounting view'}
    assert_response :success
    assert_select "tr#trsc_#{t.id}_row td.de_ow_cell", '50,000.00'
    assert_select "tr#trsc_#{t.id}_row td.cr_ow_cell", ''
    get transactions_docs_path, params: {
      type: 'invoice',
      from: Time.now.to_date.beginning_of_month,
      to: Time.now.to_date.end_of_month,
      view_user_id: @owner.id}
    assert_select "tr#trsc_#{t.id}_iv_row", count: 0 #Invoice

    # From guests
    type = TransactionType.find_by(name_en: 'From guests')
    assert_difference('Transaction.count', 1) do
      post transactions_path, params: {
                                transaction: {
                                  date: Time.now.to_date,
                                  type_id: type.id,
                                  house_id: @house.id,
                                  de_ow: 5500,
                                  comment_en: 'From guests'} }\
    end
    # assert_match 'test', response.body
    t = Transaction.last
    assert_equal 1, t.balance_outs.count
    assert_equal 5500, t.balance_outs.sum(:debit).to_i
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
    get transactions_path, params: { view_user_id: @owner.id, commit: 'Owner view'}
    assert_response :success
    assert_select "tr#trsc_#{t.id}_row td.de_ow_cell", '5,500.00'
    assert_select "tr#trsc_#{t.id}_row td.cr_ow_cell", ''
    get transactions_path, params: { view_user_id: @owner.id, commit: 'Accounting view'}
    assert_response :success
    assert_select "tr#trsc_#{t.id}_row td.de_ow_cell", '5,500.00'
    assert_select "tr#trsc_#{t.id}_row td.cr_ow_cell", ''
    get transactions_docs_path, params: {
      type: 'invoice',
      from: Time.now.to_date.beginning_of_month,
      to: Time.now.to_date.end_of_month,
      view_user_id: @owner.id}
    assert_select "tr#trsc_#{t.id}_iv_row", count: 0 #Invoice

    # Repair
    type = TransactionType.find_by(name_en: 'Repair')
    assert_difference('Transaction.count', 1) do
      post transactions_path, params: {
                                transaction: {
                                  date: Time.now.to_date,
                                  type_id: type.id,
                                  house_id: @house.id,
                                  cr_ow: 500,
                                  cr_co: 1000,
                                  de_co: 700,
                                  comment_en: 'Repair'} }
    end
    # assert_match 'test', response.body
    t = Transaction.last
    assert_equal 2, t.balance_outs.count
    assert_equal 0, t.balance_outs.sum(:debit)
    assert_equal 2200, t.balance_outs.sum(:credit)
    assert_equal 2, t.balances.count
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
    get transactions_path, params: { view_user_id: @owner.id, commit: 'Owner view'}
    assert_response :success
    assert_select "tr#trsc_#{t.id}_row td.de_ow_cell", ''
    assert_select "tr#trsc_#{t.id}_row td.cr_ow_cell", '2,200.00'
    get transactions_path, params: { view_user_id: @owner.id, commit: 'Accounting view'}
    assert_response :success
    assert_select "tr#trsc_#{t.id}_row td.de_ow_cell", ''
    assert_select "tr#trsc_#{t.id}_row td.cr_ow_cell", '500.00'
    get transactions_docs_path, params: {
      type: 'invoice',
      from: Time.now.to_date.beginning_of_month,
      to: Time.now.to_date.end_of_month,
      view_user_id: @owner.id}
    assert_select "tr#trsc_#{t.id}_iv_row td.iv_price_bvat_cell", '1,588.79' #Invoice

    # Purchases
    type = TransactionType.find_by(name_en: 'Purchases')
    assert_difference('Transaction.count', 1) do
      post transactions_path, params: {
                                transaction: {
                                  date: Time.now.to_date,
                                  type_id: type.id,
                                  house_id: @house.id,
                                  cr_ow: 7500,
                                  de_co: 1500,
                                  comment_en: 'Purchases'} }
    end
    # assert_match 'test', response.body
    t = Transaction.last
    assert_equal 2, t.balance_outs.count
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
    get transactions_path, params: { view_user_id: @owner.id, commit: 'Owner view'}
    assert_response :success
    assert_select "tr#trsc_#{t.id}_row td.de_ow_cell", ''
    assert_select "tr#trsc_#{t.id}_row td.cr_ow_cell", '9,000.00'
    get transactions_path, params: { view_user_id: @owner.id, commit: 'Accounting view'}
    assert_response :success
    assert_select "tr#trsc_#{t.id}_row td.de_ow_cell", ''
    assert_select "tr#trsc_#{t.id}_row td.cr_ow_cell", '7,500.00'
    get transactions_docs_path, params: {
      type: 'invoice',
      from: Time.now.to_date.beginning_of_month,
      to: Time.now.to_date.end_of_month,
      view_user_id: @owner.id}
    assert_select "tr#trsc_#{t.id}_iv_row td.iv_price_bvat_cell", '1,401.87' #Invoice

    # ['Utilities', 'Pest control', 'Insurance', 'Salary', 'Gasoline', 'Office', 'Suppliers', 'Equipment']
    type = TransactionType.find_by(name_en: 'Utilities')
    assert_difference('Transaction.count', 1) do
      post transactions_path, params: {
                                transaction: {
                                  date: Time.now.to_date,
                                  type_id: type.id,
                                  house_id: @house.id,
                                  cr_ow: 3500,
                                  comment_en: 'Electricity 08.2019'} }
    end
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
    get transactions_path, params: { view_user_id: @owner.id, commit: 'Owner view'}
    assert_response :success
    assert_select "tr#trsc_#{t.id}_row td.de_ow_cell", ''
    assert_select "tr#trsc_#{t.id}_row td.cr_ow_cell", '3,500.00'
    get transactions_path, params: { view_user_id: @owner.id, commit: 'Accounting view'}
    assert_response :success
    assert_select "tr#trsc_#{t.id}_row td.de_ow_cell", ''
    assert_select "tr#trsc_#{t.id}_row td.cr_ow_cell", '3,500.00'
    get transactions_docs_path, params: {
      type: 'invoice',
      from: Time.now.to_date.beginning_of_month,
      to: Time.now.to_date.end_of_month,
      view_user_id: @owner.id}
    assert_select "tr#trsc_#{t.id}_iv_row", count: 0 #Invoice

    # Add hidden from acc transaction
    @booking_2 = bookings(:_2)
    type = TransactionType.find_by(name_en: 'Rental')
    assert_difference('Transaction.count', 1) do
      post transactions_path, params: {
                                transaction: {
                                  date: Time.now.to_date,
                                  type_id: type.id,
                                  booking_id: @booking_2.id,
                                  de_ow: 30000,
                                  de_co: 6000,
                                  booking_fully_paid: false,
                                  comment_en: 'Rental cash',
                                  comment_inner: 'Rental hidden',
                                  hidden: true} }
    end
    t = Transaction.last
    assert_equal 2, t.balance_outs.count
    assert_equal 30000, t.balance_outs.sum(:debit)
    assert_equal 6000, t.balance_outs.sum(:credit)
    assert_equal 1, t.balances.count
    assert_equal 6000, t.balances.sum(:debit)
    assert_equal 0, t.balances.sum(:credit)
    assert_response :redirect
    follow_redirect!
    assert_response :success
    get transactions_path, params: { commit: 'Company view'}
    assert_response :success
    assert_select "tr#trsc_#{t.id}_row td.de_co_cell", '6,000.00'
    assert_select "tr#trsc_#{t.id}_row td.cr_co_cell", ''
    assert_select "tr#trsc_#{t.id}_row td.de_ow_cell", '30,000.00'
    assert_select "tr#trsc_#{t.id}_row td.cr_ow_cell", '6,000.00'
    get transactions_path, params: { view_user_id: @owner.id, commit: 'Owner view'}
    assert_response :success
    assert_select "tr#trsc_#{t.id}_row td.de_ow_cell", '24,000.00'
    assert_select "tr#trsc_#{t.id}_row td.cr_ow_cell", ''
    get transactions_path, params: { view_user_id: @owner.id, commit: 'Accounting view'}
    assert_response :success
    assert_select "tr.hidden_row", count: 1
    assert_select "tr#trsc_#{t.id}_row td.de_ow_cell", '30,000.00'
    assert_select "tr#trsc_#{t.id}_row td.cr_ow_cell", ''
    get transactions_docs_path, params: {
      type: 'invoice',
      from: Time.now.to_date.beginning_of_month,
      to: Time.now.to_date.end_of_month,
      view_user_id: @owner.id}
    assert_select "tr#trsc_#{t.id}_iv_row", count: 0 #Invoice

    # Add only for acc transaction
    owner = users(:owner)
    type = TransactionType.find_by(name_en: 'Other')
    assert_difference('Transaction.count', 1) do
      post transactions_path, params: {
                                transaction: {
                                  date: '31.08.2019'.to_date,
                                  type_id: type.id,
                                  user_id: owner.id,
                                  cr_ow: 10000,
                                  comment_en: 'To align balance',
                                  comment_inner: 'Hidden from owner',
                                  for_acc: true} }
    end
    t = Transaction.last
    assert_equal 1, t.balance_outs.count
    assert_equal 0, t.balance_outs.sum(:debit)
    assert_equal 10000, t.balance_outs.sum(:credit)
    assert_equal 0, t.balances.count
    assert_equal 0, t.balances.sum(:debit)
    assert_equal 0, t.balances.sum(:credit)
    assert_response :redirect
    follow_redirect!
    assert_response :success
    get transactions_path, params: { commit: 'Company view'}
    assert_response :success
    assert_select "tr#trsc_#{t.id}_row", count: 0
    assert_select "tr#trsc_#{t.id}_row", count: 0
    assert_select "tr#trsc_#{t.id}_row", count: 0
    assert_select "tr#trsc_#{t.id}_row", count: 0
    get transactions_path, params: { view_user_id: @owner.id, commit: 'Owner view'}
    assert_response :success
    assert_select "tr#trsc_#{t.id}_row", count: 0
    assert_select "tr#trsc_#{t.id}_row", count: 0
    from = '2019-08-01'
    to = Time.now.to_date
    get transactions_path, params: {  from: from, to: to, view_user_id: @owner.id, commit: 'Accounting view'}
    assert_response :success
    assert_select "tr.for_acc_row", count: 1
    assert_select "tr#trsc_#{t.id}_row td.de_ow_cell", ''
    assert_select "tr#trsc_#{t.id}_row td.cr_ow_cell", '10,000.00'
    get transactions_docs_path, params: {
      type: 'invoice',
      from: Time.now.to_date.beginning_of_month,
      to: Time.now.to_date.end_of_month,
      view_user_id: @owner.id}
    assert_select "tr#trsc_#{t.id}_iv_row", count: 0 #Invoice

    #
    # Check sums
    #
    # 24.09.2019 Standart cases
    # 25.09.2019 Hidden transactions (added within this test)
    # 25.09.2019 Previous transactions (from fixtures)
    # 09.10.2019 Hidden from owner transactions (added within this test)
    # 14.11.2019 Rental credit deducted from Owner totals

    from = '2019-09-01'
    to = Time.now.to_date
    # For specific owner: Check company view de totals = owner IV amount in acc view = Total in IV
    get transactions_path, params: { from: from, to: to, view_user_id: @owner.id, commit: 'Company view'}
    de_co_sum = @owner.transactions.joins(:balances).sum('balances.debit')
    assert_equal 73200.99.to_d, de_co_sum
    assert_select "#de_co_sum", "73,200.99"
    assert_select '#de_co_prev_sum', '7,000.00'
    assert_select '#cr_co_prev_sum', ''
    assert_select '#co_prev_balance', '7,000.00'
    get transactions_path, params: { from: from, to: to, view_user_id: @owner.id, commit: 'Accounting view'}
    assert_select "#company_maintenance", "60,200.99" #Because of hidden trsc it less 6000
    get transactions_docs_path, params: {
      type: 'invoice',
      from: from,
      to: to,
      view_user_id: @owner.id}
    assert_select "#de_co_bvat_sum", "56,262.61"
    assert_select "#vat_sum", "3,938.38"
    assert_select "#iv_de_co_sum", "60,200.99" #Because of hidden trsc  it less 6000

    # For specific owner: Owner view(back) totals Owner view(front)totals = Acc view totals = DB totals
    de_ow_sum = @owner.transactions.where(for_acc: false).joins(:balance_outs).sum('debit')
    cr_ow_sum = @owner.transactions.where(for_acc: false).joins(:balance_outs).sum('credit')
    assert_equal 322500, de_ow_sum
    assert_equal 101200.99.to_d, cr_ow_sum
    get transactions_path, params: { from: from, to: to, view_user_id: @owner.id, commit: 'Owner view'}
    assert_select '#de_ow_prev_sum', '14,000.00'
    assert_select '#cr_ow_prev_sum', ''
    assert_select '#ow_prev_balance', '14,000.00'
    assert_select "#de_ow_sum", "270,500.00" #Rental credit deducted from bebit for owner right away in owner view
    assert_select "#cr_ow_sum", "49,200.99" #Rental credit not counted because was deducted from bebit in owner view
    assert_select "#ow_balance", "221,299.01"
    get transactions_path, params: { from: from, to: to, view_user_id: @owner.id, commit: 'Accounting view'}
    assert_select '#de_ow_prev_sum', ''
    assert_select '#cr_ow_prev_sum', '3,000.00'
    assert_select '#ow_prev_balance', '-3,000.00'
    assert_select "#de_ow_sum", "285,500.00"
    assert_select "#de_ow_hidden_sum", "30,000.00"
    assert_select "#de_ow_sum_and_hidden", "315,500.00"
    assert_select "#cr_ow_sum", "105,200.99"
    assert_select "#cr_ow_hidden_sum", "6,000.00"
    assert_select "#cr_ow_sum_and_hidden", "111,200.99"
    assert_select "#ow_balance", "180,299.01"
    assert_select "#ow_balance_and_hidden", "204,299.01"

    sign_in users(:owner)
    get balance_front_path, params: { from: from, to: to}
    assert_select "#de_ow_sum", "270,500.00" #Rental credit 40000 deducted from bebit for owner right away in owner view
    assert_select "#cr_ow_sum", "49,200.99" #Rental credit 40000 deducted from bebit for owner right away in owner view
    assert_select "#ow_balance", "221,299.01"

    sign_in users(:manager)
    # All owners: Check company View totals = DB sum
    from = Transaction.minimum(:date)
    to = Transaction.maximum(:date)
    get transactions_path, params: {from: from, to: to }
    de_co_sum = Transaction.joins(:balances).sum('balances.debit')
    assert_equal 109250.99.to_d, de_co_sum
    assert_select "#de_co_sum", "109,250.99"
    cr_co_sum = Transaction.joins(:balances).sum('balances.credit')
    assert_equal 7000.99, cr_co_sum
    assert_select "#cr_co_sum", "7,000.99"

    #Prev sums

  end

  test 'Show and hide comm' do
    # if show_comm set to false Owner can not see comm
    from = '2019-09-01'
    to = Time.now.to_date
    sign_in users(:owner)
    get balance_front_path, params: { from: from, to: to}
    assert_select "td.cr_ow_net_cell", count: 0
    assert_select "td.de_co_cell", count: 0
    assert_select "td.cr_ow_cell"

    sign_in users(:admin)
    @owner = users(:owner_3)
    @house = @owner.houses.first
    # Top up
    type = TransactionType.find_by(name_en: 'Top up')
    post transactions_path, params: {
                              transaction: {
                                date: Time.now.to_date,
                                type_id: type.id,
                                house_id: @house.id,
                                de_ow: 150000,
                                comment_en: 'Top up'} }
    t = Transaction.last
    get transactions_path, params: { commit: 'Company view'}
    assert_response :success
    assert_select "tr#trsc_#{t.id}_row td.de_co_cell", ''
    assert_select "tr#trsc_#{t.id}_row td.cr_co_cell", ''
    assert_select "tr#trsc_#{t.id}_row td.de_ow_cell", '150,000.00'
    assert_select "tr#trsc_#{t.id}_row td.cr_ow_cell", ''
    get transactions_path, params: { view_user_id: @owner.id, commit: 'Owner view'}
    assert_response :success
    assert_select "tr#trsc_#{t.id}_row td.de_ow_cell", '150 000,00'
    assert_select "tr#trsc_#{t.id}_row td.cr_ow_cell", count: 0
    get transactions_path, params: { view_user_id: @owner.id, commit: 'Accounting view'}
    assert_response :success
    assert_select "tr#trsc_#{t.id}_row td.de_ow_cell", '150,000.00'
    assert_select "tr#trsc_#{t.id}_row td.cr_ow_cell", ''

    #if show_comm set to true Owner can see comm
    type = TransactionType.find_by(name_en: 'Purchases')
    assert_difference('Transaction.count', 1) do
      post transactions_path, params: {
                                transaction: {
                                  date: Time.now.to_date,
                                  type_id: type.id,
                                  house_id: @house.id,
                                  cr_ow: 20000,
                                  de_co: 2000,
                                  comment_en: 'Purchases'} }
    end
    # assert_match 'test', response.body
    t = Transaction.last
    assert_equal 2, t.balance_outs.count
    assert_equal 0, t.balance_outs.sum(:debit)
    assert_equal 22000, t.balance_outs.sum(:credit)
    assert_equal 1, t.balances.count
    assert_equal 2000, t.balances.sum(:debit)
    assert_equal 0, t.balances.sum(:credit)
    assert_response :redirect
    follow_redirect!
    assert_response :success
    get transactions_path, params: { commit: 'Company view'}
    assert_response :success
    assert_select "tr#trsc_#{t.id}_row td.de_co_cell", '2,000.00'
    assert_select "tr#trsc_#{t.id}_row td.cr_co_cell", ''
    assert_select "tr#trsc_#{t.id}_row td.de_ow_cell", ''
    assert_select "tr#trsc_#{t.id}_row td.cr_ow_cell", '22,000.00'
    get transactions_path, params: { view_user_id: @owner.id, commit: 'Owner view'}
    assert_response :success
    assert_select "tr#trsc_#{t.id}_row td.de_ow_cell", ''
    assert_select "tr#trsc_#{t.id}_row td.cr_ow_cell", count: 0
    assert_select "tr#trsc_#{t.id}_row td.cr_ow_net_cell", '20 000,00'
    assert_select "tr#trsc_#{t.id}_row td.de_co_cell", '2 000,00'
    get transactions_path, params: { view_user_id: @owner.id, commit: 'Accounting view'}
    assert_response :success
    assert_select "tr#trsc_#{t.id}_row td.de_ow_cell", ''
    assert_select "tr#trsc_#{t.id}_row td.cr_ow_cell", '20,000.00'

    sign_in users(:owner_3)
    get balance_front_path, params: { from: from, to: to}
    assert_select "tr#trsc_#{t.id}_row td.de_ow_cell", ''
    assert_select "tr#trsc_#{t.id}_row td.cr_ow_cell", count: 0
    assert_select "tr#trsc_#{t.id}_row td.cr_ow_net_cell", '20 000,00'
    assert_select "tr#trsc_#{t.id}_row td.de_co_cell", '2 000,00'
    assert_select "#de_ow_sum", "150 000,00"
    assert_select "#cr_ow_net_sum", "120 000,00"
    assert_select "#de_co_sum", "12 000,00"
    assert_select "#ow_balance", "18 000,00"
  end

  test 'Test that get warnings' do
    # Same amounts or text in same day
    # 1st record
    type = TransactionType.find_by(name_en: 'Repair')
    assert_difference('Transaction.count', 1) do
      post transactions_path, params: {
                                transaction: {
                                  date: Time.now.to_date,
                                  type_id: type.id,
                                  house_id: @house.id,
                                  cr_ow: 500,
                                  cr_co: 1000,
                                  de_co: 700,
                                  comment_en: 'Repair'} }
    end
    # 2nd record
    assert_difference('Transaction.count', 1) do
      post transactions_path, params: {
                                transaction: {
                                  date: Time.now.to_date,
                                  type_id: type.id,
                                  house_id: @house.id,
                                  cr_ow: 500,
                                  cr_co: 1000,
                                  de_co: 700,
                                  comment_en: 'Repair'} }
    end
    follow_redirect!
    assert_select ".warning", "Same day same name: #{Time.now.to_date} Repair / "
  end


end
