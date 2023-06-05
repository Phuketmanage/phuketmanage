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
        de_ow: 100_000,
        de_co: 20_000,
        booking_fully_paid: true,
        comment_en: 'Rental'
      }
    }
    t = Transaction.last
    assert_equal 2, t.balance_outs.count
    assert_equal 100_000, t.balance_outs.sum(:debit)
    assert_equal 20_000, t.balance_outs.sum(:credit)
    assert_equal 1, t.balances.count
    assert_equal 20_000, t.balances.sum(:debit)
    assert_equal 0, t.balances.sum(:credit)
    assert_response :redirect
    follow_redirect!
    assert_response :success
    get transactions_path, params: { commit: 'Full' }
    assert_response :success
    assert_select "tr#trsc_#{t.id}_row td.de_co_cell", '20,000.00'
    assert_select "tr#trsc_#{t.id}_row td.cr_co_cell", ''
    assert_select "tr#trsc_#{t.id}_row td.de_ow_cell", 0
    assert_select "tr#trsc_#{t.id}_row td.cr_ow_cell", 0
    get transactions_path, params: { owner_id: @owner.id, commit: 'Full' }
    assert_response :success
    assert_select "tr#trsc_#{t.id}_row td.de_ow_cell", '80,000.00'
    assert_select "tr#trsc_#{t.id}_row td.cr_ow_cell", ''
    get transactions_path, params: { owner_id: @owner.id, commit: 'Acc' }
    assert_response :success
    assert_select "tr#trsc_#{t.id}_row td.de_ow_cell", '100,000.00'
    assert_select "tr#trsc_#{t.id}_row td.cr_ow_cell", ''
    get transactions_docs_path, params: {
      type: 'invoice',
      from: Time.now.to_date.beginning_of_month,
      to: Time.now.to_date.end_of_month,
      view_user_id: @owner.id
    }
    assert_select "tr#trsc_#{t.id}_iv_row td.iv_price_bvat_cell", '18,691.59' # Invoice

    # Maintenance
    type = TransactionType.find_by(name_en: 'Maintenance')
    post transactions_path, params: {
      transaction: {
        date: Time.now.to_date,
        type_id: type.id,
        house_id: @house.id,
        de_co: 15_000,
        comment_en: 'Maintenance'
      }
    }
    # assert_match 'test', response.body
    t = Transaction.last
    assert_equal 1, t.balance_outs.count
    assert_equal 0, t.balance_outs.sum(:debit)
    assert_equal 15_000, t.balance_outs.sum(:credit)
    assert_equal 1, t.balances.count
    assert_equal 15_000, t.balances.sum(:debit)
    assert_equal 0, t.balances.sum(:credit)
    assert_response :redirect
    follow_redirect!
    assert_response :success
    get transactions_path, params: { commit: 'Company view' }
    assert_response :success
    assert_select "tr#trsc_#{t.id}_row td.de_co_cell", '15,000.00'
    assert_select "tr#trsc_#{t.id}_row td.cr_co_cell", ''
    assert_select "tr#trsc_#{t.id}_row td.de_ow_cell", 0
    assert_select "tr#trsc_#{t.id}_row td.cr_ow_cell", 0
    get transactions_path, params: { owner_id: @owner.id, commit: 'Full' }
    assert_response :success
    assert_select "tr#trsc_#{t.id}_row td.de_ow_cell", ''
    assert_select "tr#trsc_#{t.id}_row td.cr_ow_cell", '15,000.00'
    get transactions_path, params: { owner_id: @owner.id, commit: 'Acc' }
    assert_response :success
    assert_select "tr#trsc_#{t.id}_row", count: 0
    get transactions_docs_path, params: {
      type: 'invoice',
      from: Time.now.to_date.beginning_of_month,
      to: Time.now.to_date.end_of_month,
      view_user_id: @owner.id
    }
    assert_select "tr#trsc_#{t.id}_iv_row td.iv_price_bvat_cell", '14,018.69' # Invoice

    # Laundry
    type = TransactionType.find_by(name_en: 'Laundry')
    post transactions_path, params: {
      transaction: {
        date: Time.now.to_date,
        type_id: type.id,
        house_id: @house.id,
        de_co: 300,
        comment_en: 'Laundry'
      }
    }
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
    get transactions_path, params: { commit: 'Full' }
    assert_response :success
    assert_select "tr#trsc_#{t.id}_row td.de_co_cell", '300.00'
    assert_select "tr#trsc_#{t.id}_row td.cr_co_cell", ''
    assert_select "tr#trsc_#{t.id}_row td.de_ow_cell", 0
    assert_select "tr#trsc_#{t.id}_row td.cr_ow_cell", 0
    get transactions_path, params: { owner_id: @owner.id, commit: 'Full' }
    assert_response :success
    assert_select "tr#trsc_#{t.id}_row td.de_ow_cell", ''
    assert_select "tr#trsc_#{t.id}_row td.cr_ow_cell", '300.00'
    get transactions_path, params: { owner_id: @owner.id, commit: 'Acc' }
    assert_response :success
    assert_select "tr#trsc_#{t.id}_row", count: 0
    get transactions_docs_path, params: {
      type: 'invoice',
      from: Time.now.to_date.beginning_of_month,
      to: Time.now.to_date.end_of_month,
      view_user_id: @owner.id
    }
    assert_select "tr#trsc_#{t.id}_iv_row td.iv_price_bvat_cell", '280.37' # Invoice

    # Top up
    type = TransactionType.find_by(name_en: 'Top up')
    post transactions_path, params: {
      transaction: {
        date: Time.now.to_date,
        type_id: type.id,
        house_id: @house.id,
        de_ow: 50_000,
        comment_en: 'Top up'
      }
    }
    # assert_match 'test', response.body
    t = Transaction.last
    assert_equal 1, t.balance_outs.count
    assert_equal 50_000, t.balance_outs.sum(:debit)
    assert_equal 0, t.balance_outs.sum(:credit)
    assert_equal 0, t.balances.count
    assert_equal 0, t.balances.sum(:debit)
    assert_equal 0, t.balances.sum(:credit)
    assert_response :redirect
    follow_redirect!
    assert_response :success
    get transactions_path, params: { commit: 'Full' }
    assert_response :success
    assert_select "tr#trsc_#{t.id}_row td.de_co_cell", ''
    assert_select "tr#trsc_#{t.id}_row td.cr_co_cell", ''
    assert_select "tr#trsc_#{t.id}_row td.de_ow_cell", 0
    assert_select "tr#trsc_#{t.id}_row td.cr_ow_cell", 0
    get transactions_path, params: { owner_id: @owner.id, commit: 'Full' }
    assert_response :success
    assert_select "tr#trsc_#{t.id}_row td.de_ow_cell", '50,000.00'
    assert_select "tr#trsc_#{t.id}_row td.cr_ow_cell", ''
    get transactions_path, params: { owner_id: @owner.id, commit: 'Acc' }
    assert_response :success
    assert_select "tr#trsc_#{t.id}_row td.de_ow_cell", '50,000.00'
    assert_select "tr#trsc_#{t.id}_row td.cr_ow_cell", ''
    get transactions_docs_path, params: {
      type: 'invoice',
      from: Time.now.to_date.beginning_of_month,
      to: Time.now.to_date.end_of_month,
      view_user_id: @owner.id
    }
    assert_select "tr#trsc_#{t.id}_iv_row", count: 0 # Invoice

    # From guests
    type = TransactionType.find_by(name_en: 'From guests')
    assert_difference('Transaction.count', 1) do
      post transactions_path, params: {
        transaction: {
          date: Time.now.to_date,
          type_id: type.id,
          house_id: @house.id,
          de_ow: 5500,
          comment_en: 'From guests'
        }
      } \
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
    get transactions_path, params: { commit: 'Full' }
    assert_response :success
    assert_select "tr#trsc_#{t.id}_row td.de_co_cell", ''
    assert_select "tr#trsc_#{t.id}_row td.cr_co_cell", ''
    assert_select "tr#trsc_#{t.id}_row td.de_ow_cell", 0
    assert_select "tr#trsc_#{t.id}_row td.cr_ow_cell", 0
    get transactions_path, params: { owner_id: @owner.id, commit: 'Full' }
    assert_response :success
    assert_select "tr#trsc_#{t.id}_row td.de_ow_cell", '5,500.00'
    assert_select "tr#trsc_#{t.id}_row td.cr_ow_cell", ''
    get transactions_path, params: { owner_id: @owner.id, commit: 'Acc' }
    assert_response :success
    assert_select "tr#trsc_#{t.id}_row td.de_ow_cell", '5,500.00'
    assert_select "tr#trsc_#{t.id}_row td.cr_ow_cell", ''
    get transactions_docs_path, params: {
      type: 'invoice',
      from: Time.now.to_date.beginning_of_month,
      to: Time.now.to_date.end_of_month,
      view_user_id: @owner.id
    }
    assert_select "tr#trsc_#{t.id}_iv_row", count: 0 # Invoice

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
          comment_en: 'Repair'
        }
      }
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
    get transactions_path, params: { commit: 'Full' }
    assert_response :success
    assert_select "tr#trsc_#{t.id}_row td.de_co_cell", '1,700.00'
    assert_select "tr#trsc_#{t.id}_row td.cr_co_cell", '1,000.00'
    assert_select "tr#trsc_#{t.id}_row td.de_ow_cell", 0
    assert_select "tr#trsc_#{t.id}_row td.cr_ow_cell", 0
    get transactions_path, params: { owner_id: @owner.id, commit: 'Full' }
    assert_response :success
    assert_select "tr#trsc_#{t.id}_row td.de_ow_cell", ''
    assert_select "tr#trsc_#{t.id}_row td.cr_ow_cell", '2,200.00'
    get transactions_path, params: { owner_id: @owner.id, commit: 'Acc' }
    assert_response :success
    assert_select "tr#trsc_#{t.id}_row td.de_ow_cell", ''
    assert_select "tr#trsc_#{t.id}_row td.cr_ow_cell", '500.00'
    get transactions_docs_path, params: {
      type: 'invoice',
      from: Time.now.to_date.beginning_of_month,
      to: Time.now.to_date.end_of_month,
      view_user_id: @owner.id
    }
    assert_select "tr#trsc_#{t.id}_iv_row td.iv_price_bvat_cell", '1,588.79' # Invoice

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
          comment_en: 'Purchases'
        }
      }
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
    get transactions_path, params: { commit: 'Full' }
    assert_response :success
    assert_select "tr#trsc_#{t.id}_row td.de_co_cell", '1,500.00'
    assert_select "tr#trsc_#{t.id}_row td.cr_co_cell", ''
    assert_select "tr#trsc_#{t.id}_row td.de_ow_cell", 0
    assert_select "tr#trsc_#{t.id}_row td.cr_ow_cell", 0
    get transactions_path, params: { owner_id: @owner.id, commit: 'Full' }
    assert_response :success
    assert_select "tr#trsc_#{t.id}_row td.de_ow_cell", ''
    assert_select "tr#trsc_#{t.id}_row td.cr_ow_cell", '9,000.00'
    get transactions_path, params: { owner_id: @owner.id, commit: 'Acc' }
    assert_response :success
    assert_select "tr#trsc_#{t.id}_row td.de_ow_cell", ''
    assert_select "tr#trsc_#{t.id}_row td.cr_ow_cell", '7,500.00'
    get transactions_docs_path, params: {
      type: 'invoice',
      from: Time.now.to_date.beginning_of_month,
      to: Time.now.to_date.end_of_month,
      view_user_id: @owner.id
    }
    assert_select "tr#trsc_#{t.id}_iv_row td.iv_price_bvat_cell", '1,401.87' # Invoice

    # ['Utilities', 'Pest control', 'Insurance', 'Salary', 'Gasoline', 'Office', 'Suppliers', 'Equipment']
    type = TransactionType.find_by(name_en: 'Utilities')
    assert_difference('Transaction.count', 1) do
      post transactions_path, params: {
        transaction: {
          date: Time.now.to_date,
          type_id: type.id,
          house_id: @house.id,
          cr_ow: 3500,
          comment_en: 'Electricity 08.2019'
        }
      }
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
    get transactions_path, params: { commit: 'Company view' }
    assert_response :success
    assert_select "tr#trsc_#{t.id}_row td.de_co_cell", ''
    assert_select "tr#trsc_#{t.id}_row td.cr_co_cell", ''
    get transactions_path, params: { owner_id: @owner.id, commit: 'Owner view' }
    assert_response :success
    assert_select "tr#trsc_#{t.id}_row td.de_ow_cell", ''
    assert_select "tr#trsc_#{t.id}_row td.cr_ow_cell", '3,500.00'
    get transactions_path, params: { owner_id: @owner.id, commit: 'Accounting view' }
    assert_response :success
    assert_select "tr#trsc_#{t.id}_row td.de_ow_cell", ''
    assert_select "tr#trsc_#{t.id}_row td.cr_ow_cell", '3,500.00'
    get transactions_docs_path, params: {
      type: 'invoice',
      from: Time.now.to_date.beginning_of_month,
      to: Time.now.to_date.end_of_month,
      view_user_id: @owner.id
    }
    assert_select "tr#trsc_#{t.id}_iv_row", count: 0 # Invoice

    # Add hidden from acc transaction
    @booking_2 = bookings(:_2)
    type = TransactionType.find_by(name_en: 'Rental')
    assert_difference('Transaction.count', 1) do
      post transactions_path, params: {
        transaction: {
          date: Time.now.to_date,
          type_id: type.id,
          booking_id: @booking_2.id,
          de_ow: 30_000,
          de_co: 6000,
          booking_fully_paid: false,
          comment_en: 'Rental cash',
          comment_inner: 'Rental hidden',
          hidden: true
        }
      }
    end
    t = Transaction.last
    assert_equal 2, t.balance_outs.count
    assert_equal 30_000, t.balance_outs.sum(:debit)
    assert_equal 6000, t.balance_outs.sum(:credit)
    assert_equal 1, t.balances.count
    assert_equal 6000, t.balances.sum(:debit)
    assert_equal 0, t.balances.sum(:credit)
    assert_response :redirect
    follow_redirect!
    assert_response :success
    get transactions_path, params: { commit: 'Full' }
    assert_response :success
    assert_select "tr#trsc_#{t.id}_row td.de_co_cell", '6,000.00'
    assert_select "tr#trsc_#{t.id}_row td.cr_co_cell", ''
    assert_select "tr#trsc_#{t.id}_row td.de_ow_cell", 0
    assert_select "tr#trsc_#{t.id}_row td.cr_ow_cell", 0
    get transactions_path, params: { owner_id: @owner.id, commit: 'Full' }
    assert_response :success
    assert_select "tr#trsc_#{t.id}_row td.de_ow_cell", '24,000.00'
    assert_select "tr#trsc_#{t.id}_row td.cr_ow_cell", ''
    get transactions_path, params: { owner_id: @owner.id, commit: 'Acc' }
    assert_response :success
    get transactions_docs_path, params: {
      type: 'invoice',
      from: Time.now.to_date.beginning_of_month,
      to: Time.now.to_date.end_of_month,
      view_user_id: @owner.id
    }
    assert_select "tr#trsc_#{t.id}_iv_row", count: 0 # Invoice

    # Add only for acc transaction
    owner = users(:owner)
    type = TransactionType.find_by(name_en: 'Other')
    assert_difference('Transaction.count', 1) do
      post transactions_path, params: {
        transaction: {
          date: '31.08.2019'.to_date,
          type_id: type.id,
          user_id: owner.id,
          cr_ow: 10_000,
          comment_en: 'To align balance',
          comment_inner: 'Hidden from owner',
          for_acc: true
        }
      }
    end
    t = Transaction.last
    assert_equal 1, t.balance_outs.count
    assert_equal 0, t.balance_outs.sum(:debit)
    assert_equal 10_000, t.balance_outs.sum(:credit)
    assert_equal 0, t.balances.count
    assert_equal 0, t.balances.sum(:debit)
    assert_equal 0, t.balances.sum(:credit)
    assert_response :redirect
    follow_redirect!
    assert_response :success
    get transactions_path, params: { commit: 'Full' }
    assert_response :success
    assert_select "tr#trsc_#{t.id}_row", count: 0
    assert_select "tr#trsc_#{t.id}_row", count: 0
    assert_select "tr#trsc_#{t.id}_row", count: 0
    assert_select "tr#trsc_#{t.id}_row", count: 0
    get transactions_path, params: { owner_id: @owner.id, commit: 'Full' }
    assert_response :success
    assert_select "tr#trsc_#{t.id}_row", count: 0
    assert_select "tr#trsc_#{t.id}_row", count: 0
    from = '2019-08-01'
    to = Time.now.to_date
    get transactions_path, params: { from: from, to: to, owner_id: @owner.id, commit: 'Acc' }
    assert_response :success
    assert_select "tr.for_acc_row", count: 1
    assert_select "tr#trsc_#{t.id}_row td.de_ow_cell", ''
    assert_select "tr#trsc_#{t.id}_row td.cr_ow_cell", '10,000.00'
    get transactions_docs_path, params: {
      type: 'invoice',
      from: Time.now.to_date.beginning_of_month,
      to: Time.now.to_date.end_of_month,
      view_user_id: @owner.id
    }
    assert_select "tr#trsc_#{t.id}_iv_row", count: 0 # Invoice

    #
    # Check sums
    #
    # 24.09.2019 Standart cases
    # 25.09.2019 Hidden transactions (added within this test)
    # 25.09.2019 Previous transactions (from fixtures)
    # 09.10.2019 Hidden from owner transactions (added within this test)
    # 14.11.2019 Rental credit deducted from Owner totals
    # 28.07.2022 Company view for owner was removed

    from = '2019-09-01'
    to = Time.now.to_date
    # For specific owner: Check company view de totals = owner IV amount in acc view = Total in IV
    get transactions_path, params: { from: from, to: to, owner_id: @owner.id, commit: 'Full' }
    de_co_sum = @owner.transactions.joins(:balances).sum('balances.debit')
    assert_equal BigDecimal('73_200.99').round(2), de_co_sum.round(2)
    # </28.07.2022
    # assert_select "#de_co_sum", "73,200.99"
    # assert_select '#de_co_prev_sum', ''
    # assert_select '#cr_co_prev_sum', ''
    # assert_select '#co_prev_balance', '7,000.00'
    # 28.07.2022/>
    get transactions_path, params: { from: from, to: to, owner_id: @owner.id, commit: 'Acc' }
    assert_select "#company_maintenance", "60,200.99" # Because of hidden trsc it less 6000
    get transactions_docs_path, params: {
      type: 'invoice',
      from: from,
      to: to,
      view_user_id: @owner.id
    }
    assert_select "#de_co_bvat_sum", "56,262.61"
    assert_select "#vat_sum", "3,938.38"
    assert_select "#iv_de_co_sum", "60,200.99" # Because of hidden trsc  it less 6000

    # For specific owner: Owner view(back) totals Owner view(front)totals = Acc view totals = DB totals
    de_ow_sum = @owner.transactions.where(for_acc: false).joins(:balance_outs).sum('debit')
    cr_ow_sum = @owner.transactions.where(for_acc: false).joins(:balance_outs).sum('credit')
    assert_equal 322_500, de_ow_sum
    assert_equal BigDecimal('101_200.99'), cr_ow_sum
    get transactions_path, params: { from: from, to: to, owner_id: @owner.id, commit: 'Full' }
    assert_select '#de_ow_prev_sum', ''
    assert_select '#cr_ow_prev_sum', ''
    assert_select '#ow_prev_balance', '14,000.00'
    assert_select "#de_ow_sum", "239,500.00" # Rental credit deducted from bebit for owner right away in owner view
    assert_select "#cr_ow_sum", "32,200.99" # Rental credit not counted because was deducted from bebit in owner view
    assert_select "#ow_balance", "221,299.01"
    get transactions_path, params: { from: from, to: to, owner_id: @owner.id, commit: 'Acc' }
    assert_select '#de_ow_prev_sum', ''
    assert_select '#cr_ow_prev_sum', ''
    assert_select '#ow_prev_balance', '-3,000.00'
    assert_select "#de_ow_sum", "255,500.00"
    assert_select "#cr_ow_sum", "72,200.99"
    assert_select "#ow_balance", "180,299.01"

    # View same as owner
    sign_in users(:owner)
    get balance_front_path, params: { from: from, to: to }
    assert_select "#de_ow_sum", "239,500.00" # Rental credit 40000 deducted from debit for owner right away in owner view
    assert_select "#cr_ow_sum", "32,200.99" # Rental credit 40000 deducted from debit for owner right away in owner view
    assert_select "#ow_balance", "221,299.01"

    sign_in users(:manager)
    # All owners: Check company View totals = DB sum
    from = Transaction.minimum(:date)
    to = Transaction.maximum(:date)
    get transactions_path, params: { from: from, to: to }
    de_co_sum = Transaction.joins(:balances).sum('balances.debit')
    assert_equal BigDecimal('109_250.99'), de_co_sum
    assert_select "#de_co_sum", "109,250.99"
    cr_co_sum = Transaction.joins(:balances).sum('balances.credit')
    assert_equal 7000.99, cr_co_sum
    assert_select "#cr_co_sum", "7,000.99"

    # Prev sums
  end

  test 'show payment type' do
    from = '2022-09-01'
    to = '2023-05-31'
    sign_in users(:admin)
    get transactions_path, params: { from: from, to: to, commit: 'Full' }
    assert_response :success
    assert_select "td.comment", "house rental\n          /C"
    sign_out users(:admin)
    sign_in users(:manager)
    get transactions_path, params: { from: from, to: to, commit: 'Full' }
    assert_response :success
    assert_select "td.comment", "house rental\n          /C"
    sign_out users(:manager)
    sign_in users(:owner_3)
    get transactions_path, params: { from: from, to: to, commit: 'Full' }
    assert_response :success
    assert_select "td.comment", "Аренда дома"
    sign_out users(:owner_3)
  end

  test 'Balance column should show for admin' do
    from = '2019-09-10'
    to = '2023-05-31'
    sign_in users(:admin)
    get transactions_path, params: { from: from, to: to, commit: 'Full' }
    assert_response :success
    assert_select "th.balance", "Balance"
    assert_select "td#co_prev_balance", "7,000.00"
    assert_select "td.balance_sum_cell", "27,000.00"
    assert_select "td#co_balance", "58,750.00"
    sign_out users(:admin)
    sign_in users(:accounting)
    get transactions_path, params: { from: from, to: to, commit: 'Full' }
    assert_response :success
    assert_select "th.balance", false
    assert_select "td#co_prev_balance", 0
    assert_select "td.balance_sum_cell", 0
    assert_select "td#co_balance", 0
    sign_out users(:accounting)
    sign_in users(:manager)
    get transactions_path, params: { from: from, to: to, commit: 'Full' }
    assert_response :success
    assert_select "th.balance", false
    assert_select "td#co_prev_balance", 0
    assert_select "td.balance_sum_cell", 0 
    assert_select "td#co_balance", 0
    sign_out users(:manager)
  end

  test 'Show and hide comm' do
    # if show_comm set to false Owner can not see comm
    from = '2019-09-01'
    to = Time.now.to_date
    sign_in users(:owner)
    get balance_front_path, params: { from: from, to: to }
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
        de_ow: 150_000,
        comment_en: 'Top up'
      }
    }
    t = Transaction.last
    get transactions_path, params: { commit: 'Full' }
    assert_response :success
    assert_select "tr#trsc_#{t.id}_row td.de_co_cell", ''
    assert_select "tr#trsc_#{t.id}_row td.cr_co_cell", ''
    assert_select "tr#trsc_#{t.id}_row td.de_ow_cell", 0
    assert_select "tr#trsc_#{t.id}_row td.cr_ow_cell", 0
    get transactions_path, params: { owner_id: @owner.id, commit: 'Full' }
    assert_response :success
    assert_select "tr#trsc_#{t.id}_row td.de_ow_cell", '150,000.00'
    assert_select "tr#trsc_#{t.id}_row td.cr_ow_cell", count: 0
    get transactions_path, params: { owner_id: @owner.id, commit: 'Acc' }
    assert_response :success
    assert_select "tr#trsc_#{t.id}_row td.de_ow_cell", '150,000.00'
    assert_select "tr#trsc_#{t.id}_row td.cr_ow_cell", ''

    # if show_comm set to true Owner can see comm
    type = TransactionType.find_by(name_en: 'Purchases')
    assert_difference('Transaction.count', 1) do
      post transactions_path, params: {
        transaction: {
          date: Time.now.to_date,
          type_id: type.id,
          house_id: @house.id,
          cr_ow: 20_000,
          de_co: 2000,
          comment_en: 'Purchases'
        }
      }
    end
    # assert_match 'test', response.body
    t = Transaction.last
    assert_equal 2, t.balance_outs.count
    assert_equal 0, t.balance_outs.sum(:debit)
    assert_equal 22_000, t.balance_outs.sum(:credit)
    assert_equal 1, t.balances.count
    assert_equal 2000, t.balances.sum(:debit)
    assert_equal 0, t.balances.sum(:credit)
    assert_response :redirect
    follow_redirect!
    assert_response :success
    get transactions_path, params: { commit: 'Full' }
    assert_response :success
    assert_select "tr#trsc_#{t.id}_row td.de_co_cell", '2,000.00'
    assert_select "tr#trsc_#{t.id}_row td.cr_co_cell", ''
    assert_select "tr#trsc_#{t.id}_row td.de_ow_cell", 0
    assert_select "tr#trsc_#{t.id}_row td.cr_ow_cell", 0
    get transactions_path, params: { owner_id: @owner.id, commit: 'Full' }
    assert_response :success
    assert_select "tr#trsc_#{t.id}_row td.de_ow_cell", ''
    assert_select "tr#trsc_#{t.id}_row td.cr_ow_cell", count: 0
    assert_select "tr#trsc_#{t.id}_row td.cr_ow_net_cell", '20,000.00'
    assert_select "tr#trsc_#{t.id}_row td.de_co_cell", '2,000.00'
    get transactions_path, params: { owner_id: @owner.id, commit: 'Acc' }
    assert_response :success
    assert_select "tr#trsc_#{t.id}_row td.de_ow_cell", ''
    assert_select "tr#trsc_#{t.id}_row td.cr_ow_cell", '20,000.00'

    sign_in users(:owner_3)
    get balance_front_path, params: { from: from, to: to }
    assert_select "tr#trsc_#{t.id}_row td.de_ow_cell", ''
    assert_select "tr#trsc_#{t.id}_row td.cr_ow_cell", count: 0
    assert_select "tr#trsc_#{t.id}_row td.cr_ow_net_cell", '20 000,00'
    assert_select "tr#trsc_#{t.id}_row td.de_co_cell", '2 000,00'
    assert_select "#de_ow_sum", "150 000,00"
    assert_select "#cr_ow_net_sum", "120 000,00"
    assert_select "#de_co_sum", "12 000,00"
    assert_select "#ow_balance", "18 000,00"
  end
  
  test 'should show files in company view' do
    from = '2019-08-01'
    to = Time.now.to_date
    sign_in users(:admin)
    get transactions_path, params: { from: from, to: to}
    assert_response :success
    assert_select "th", "Files"
    assert_match "Files(2)", response.body
  end
  
  test 'Test that get warnings' do
    # For company
    # 1st record
    type = TransactionType.find_by(name_en: 'Salary')
    assert_difference('Transaction.count', 1) do
      post transactions_path, params: {
        transaction: {
          date: Time.now.to_date,
          type_id: type.id,
          cr_co: 35_000,
          comment_en: 'Salary'
        }
      }
    end
    # 2nd record catch comment_en
    get transaction_warnings_path, params: {
                                     type: 'text',
                                     date: Time.now.to_date,
                                     user_id: "",
                                     field: 'transaction_comment_en',
                                     text: "salary"
                                   },
                                   xhr: true
    warning = JSON.parse(@response.body)
    assert_equal "There is one more transaction with simillar name on this date", warning['warning']

    # 2nd record pass comment_en
    get transaction_warnings_path,  params: {
                                      type: 'text',
                                      date: Time.now.to_date,
                                      user_id: "",
                                      field: 'transaction_comment_en',
                                      text: "Different text"
                                    },
                                    xhr: true
    warning = JSON.parse(@response.body)
    assert_equal "", warning['warning']

    # 2nd record catch cr_co
    get transaction_warnings_path, params: {
                                     type: 'number',
                                     date: Time.now.to_date,
                                     user_id: "",
                                     field: 'transaction_cr_co',
                                     text: "35000"
                                   },
                                   xhr: true
    warning = JSON.parse(@response.body)
    assert_equal "There is one more transaction with same amount on this date", warning['warning']

    # 2nd record pass cr_co
    get transaction_warnings_path,  params: {
                                      type: 'number',
                                      date: Time.now.to_date,
                                      user_id: "",
                                      field: 'transaction_cr_co',
                                      text: "5000"
                                    },
                                    xhr: true
    warning = JSON.parse(@response.body)
    assert_equal "", warning['warning']

    # For owner
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
          comment_en: 'Door',
          comment_ru: 'Дверь'
        }
      }
    end
    user_id = @house.owner_id
    # 2nd record catch for comment_en
    get transaction_warnings_path, params: {
                                     type: 'text',
                                     date: Time.now.to_date,
                                     user_id: user_id,
                                     field: 'transaction_comment_en',
                                     text: "door"
                                   },
                                   xhr: true
    warning = JSON.parse(@response.body)
    assert_equal "There is one more transaction with simillar name on this date", warning['warning']
    # 2nd record pass for comment_en
    get transaction_warnings_path,  params: {
                                      type: 'text',
                                      date: Time.now.to_date,
                                      user_id: user_id,
                                      field: 'transaction_comment_en',
                                      text: "door 1"
                                    },
                                    xhr: true
    warning = JSON.parse(@response.body)
    assert_equal "", warning['warning']
    # 2nd record catch for comment_ru
    get transaction_warnings_path, params: {
                                     type: 'text',
                                     date: Time.now.to_date,
                                     user_id: user_id,
                                     field: 'transaction_comment_ru',
                                     text: "Дверь"
                                   },
                                   xhr: true
    warning = JSON.parse(@response.body)
    assert_equal "There is one more transaction with simillar name on this date", warning['warning']
    # 2nd record pass for comment_ru
    get transaction_warnings_path,  params: {
                                      type: 'text',
                                      date: Time.now.to_date,
                                      user_id: user_id,
                                      field: 'transaction_comment_ru',
                                      text: "Дверь 1"
                                    },
                                    xhr: true
    warning = JSON.parse(@response.body)
    assert_equal "", warning['warning']
    # 2nd record catch for cr_co+de_co
    get transaction_warnings_path, params: {
                                     type: 'number',
                                     is_sum: 'true',
                                     date: Time.now.to_date,
                                     user_id: user_id,
                                     field: 'transaction_de_co',
                                     text: "1700"
                                   },
                                   xhr: true
    warning = JSON.parse(@response.body)
    assert_equal "There is one more transaction with same cr_co+de_co on this date", warning['warning']
    # 2nd record pass for cr_co+de_co
    get transaction_warnings_path,  params: {
                                      type: 'number',
                                      is_sum: 'true',
                                      date: Time.now.to_date,
                                      user_id: user_id,
                                      field: 'transaction_de_co',
                                      text: "170"
                                    },
                                    xhr: true
    warning = JSON.parse(@response.body)
    assert_equal "", warning['warning']

    # 1st record Rental
    type = TransactionType.find_by(name_en: 'Rental')
    post transactions_path, params: {
      transaction: {
        date: Time.now.to_date,
        type_id: type.id,
        booking_id: @booking.id,
        de_ow: 100_000,
        de_co: 20_000,
        booking_fully_paid: true,
        comment_en: 'Rental'
      }
    }

    user_id = @booking.house.owner_id
    # 2nd record rental de_ow catch
    get transaction_warnings_path, params: {
                                     type: 'number',
                                     date: Time.now.to_date,
                                     user_id: user_id,
                                     field: 'transaction_de_ow',
                                     text: "100000"
                                   },
                                   xhr: true
    warning = JSON.parse(@response.body)
    assert_equal "There is one more transaction with same amount on this date", warning['warning']
    # 2nd record rental de_ow pass
    get transaction_warnings_path,  params: {
                                      type: 'number',
                                      date: Time.now.to_date,
                                      user_id: user_id,
                                      field: 'transaction_de_ow',
                                      text: "1000"
                                    },
                                    xhr: true
    warning = JSON.parse(@response.body)
    assert_equal "", warning['warning']
    # 2nd record rental de_co catch
    get transaction_warnings_path, params: {
                                     type: 'number',
                                     date: Time.now.to_date,
                                     user_id: user_id,
                                     field: 'transaction_de_co',
                                     text: "20000"
                                   },
                                   xhr: true
    warning = JSON.parse(@response.body)
    assert_equal "There is one more transaction with same amount on this date", warning['warning']
    # 2nd record rental de_co pass
    get transaction_warnings_path,  params: {
                                      type: 'number',
                                      date: Time.now.to_date,
                                      user_id: user_id,
                                      field: 'transaction_de_co',
                                      text: "2000"
                                    },
                                    xhr: true
    warning = JSON.parse(@response.body)
    assert_equal "", warning['warning']

    # 1st record Utilities
    type = TransactionType.find_by(name_en: 'Utilities')
    assert_difference('Transaction.count', 1) do
      post transactions_path, params: {
        transaction: {
          date: Time.now.to_date,
          type_id: type.id,
          house_id: @house.id,
          cr_ow: 3500,
          comment_en: 'Electricity 08.2019'
        }
      }
    end
    # 2nd record rental cr_ow catch
    get transaction_warnings_path, params: {
                                     type: 'number',
                                     date: Time.now.to_date,
                                     user_id: user_id,
                                     field: 'transaction_cr_ow',
                                     text: "3500"
                                   },
                                   xhr: true
    warning = JSON.parse(@response.body)
    assert_equal "There is one more transaction with same amount on this date", warning['warning']
    # 2nd record rental cr_ow pass
    get transaction_warnings_path,  params: {
                                      type: 'number',
                                      date: Time.now.to_date,
                                      user_id: user_id,
                                      field: 'transaction_cr_ow',
                                      text: "350"
                                    },
                                    xhr: true
    warning = JSON.parse(@response.body)
    assert_equal "", warning['warning']
  end

  test 'acc view for company' do
    sign_in users(:admin)
    from = '2019-08-1'
    to = Time.now.to_date
    get transactions_path, params: { from: from, to: to, commit: 'Acc' }
    assert_response :success
    # warning = JSON.parse(@response.body)
    assert_select "tr.trsc_row", 8

    # Add hidden transaction and check that amount of transctions in accounting view do not change
    type = TransactionType.find_by(name_en: 'Suppliers')
    assert_difference('Transaction.count', 1) do
      post transactions_path, params: {
        transaction: {
          date: Time.now.to_date,
          type_id: type.id,
          cr_co: 13000,
          comment_en: 'Tiling wall',
          hidden: true
        }
      }
    end
    get transactions_path, params: { from: from, to: to, commit: 'Acc' }
    assert_response :success
    assert_select "tr.trsc_row", 8

    # Add normal transaction and check that amount of transctions in accounting view change
    type = TransactionType.find_by(name_en: 'Gasoline')
    assert_difference('Transaction.count', 1) do
      post transactions_path, params: {
        transaction: {
          date: Time.now.to_date,
          type_id: type.id,
          cr_co: 1800,
          comment_en: 'Gas',
        }
      }
    end
    get transactions_path, params: { from: from, to: to, commit: 'Acc' }
    assert_response :success
    assert_select "tr.trsc_row", 9

    # Manager can not see salary
    type = TransactionType.find_by(name_en: 'Salary')
    assert_difference('Transaction.count', 1) do
      post transactions_path, params: {
        transaction: {
          date: Time.now.to_date,
          type_id: type.id,
          cr_co: 18000,
          comment_en: 'Salary Tech'
        }
      }
    end
    get transactions_path, params: { from: from, to: to, commit: 'Acc' }
    assert_response :success
    assert_select "tr.trsc_row", 10
    assert_select "tr.trsc_row td.comment", {count: 1, text: "Salary Tech"}
    sign_out users(:admin)
    sign_in users(:manager)
    get transactions_path, params: { from: from, to: to, commit: 'Acc' }
    assert_response :success
    assert_select "tr.trsc_row", 9
    assert_select "tr.trsc_row td.comment", {count: 0, text: "Salary Tech"}
  end

  test "for_acc records cause mistakes" do #24.05.2023

    #Company full balance does not show for_acc records but count them in totals
    #For_acc records excluded from previous balance and from requested period
    type = TransactionType.find_by(name_en: 'Rental')
    assert_difference('Transaction.count', 1) do
      post transactions_path, params: {
        transaction: {
          date: '2019-09-5',
          type_id: type.id,
          booking_id: @booking.id,
          de_ow: 20000,
          de_co: 4000,
          booking_fully_paid: false,
          comment_en: 'Rental period ...',
          for_acc: true
        }
      }
    end
    from = '2019-08-1'
    to = '2019-09-10'
    get transactions_path, params: { from: from, to: to, commit: 'Full' }
    # get transaction after new and check that balance is 27,000 and not 31,000 that include just created
    tr_after = transactions(:one)
    assert_select "tr#trsc_#{tr_after.id}_row td.balance_sum_cell", '27,000.00'
    assert_select "td#de_co_sum", '27,000.00'
    # test that for_acc not counted in before transactions also
    from = '2019-09-10'
    to = '2019-09-12'
    get transactions_path, params: { from: from, to: to, commit: 'Full' }
    assert_select "td#de_co_sum", '54,750.99'
    # check for manager
    sign_in users(:manager)
    from = '2019-08-1'
    to = '2019-09-10'
    get transactions_path, params: { from: from, to: to, commit: 'Full' }
    assert_select "td#de_co_sum", '27,000.00'
  end

  test "should change booking status" do
    # Create booking
    month = Time.now.month+1
    year = Time.now.year
    start = "10.#{month}.#{year}"
    finish = "25.#{month}.#{year}"
    house = houses(:villa_1)
    assert_difference 'Booking.count', 1 do
      post bookings_path params: { booking: { start: start,
                                              finish: finish,
                                              house_id: house.id,
                                              status: 'pending',
                                              client_details: 'Test client' } }
    end
    b = Booking.last
    b.update(sale: 100000, agent: 0, comm: 20000, nett: 80000)
    # Add payment 50% booking status change to confirmed
    type = TransactionType.find_by(name_en: 'Rental')
    assert_difference 'Transaction.count', 1 do
      post transactions_path, params: {
        transaction: {
          date: Time.now.to_date,
          type_id: type.id,
          booking_id: b.id,
          de_ow: 50000,
          de_co: 10000,
          comment_en: 'Rental payment 1'
        }
      }
    end
    t1 = Transaction.last
    b.reload
    assert_equal 'confirmed', b.status

    # Add payment another 50% booking status change to paid
    assert_difference 'Transaction.count', 1 do
      post transactions_path, params: {
        transaction: {
          date: Time.now.to_date,
          type_id: type.id,
          booking_id: b.id,
          de_ow: 50000,
          de_co: 10000,
          comment_en: 'Rental payment 2'
        }
      }
    end
    t2 = Transaction.last
    b.reload
    assert_equal 'paid', b.status

    # After remove 1 transaction booking status change to confirmed
    assert_difference('Transaction.count', -1) do
      delete transaction_url(t2)
    end
    b.reload
    assert_equal 'confirmed', b.status


    # After remove all transactions booking status change to pending
    assert_difference('Transaction.count', -1) do
      delete transaction_url(t1)
    end
    b.reload
    assert_equal 'pending', b.status


  end

end
