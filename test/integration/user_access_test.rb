require 'test_helper'

class UserAccessTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test 'settings' do
    sign_in users(:admin)
    get settings_path
    assert_response :success

    sign_in users(:manager)
    get settings_path
    assert_redirected_to root_path
    follow_redirect!
    assert_select 'div.alert', 'You are not authorized to access this page.'

    sign_in users(:owner)
    get settings_path
    assert_redirected_to root_path
    follow_redirect!
    assert_select 'div.alert', 'You are not authorized to access this page.'

    sign_in users(:tenant)
    get settings_path
    assert_redirected_to root_path
    follow_redirect!
    assert_select 'div.alert', 'You are not authorized to access this page.'

    sign_in users(:owner_tenant)
    get settings_path
    assert_redirected_to root_path
    follow_redirect!
    assert_select 'div.alert', 'You are not authorized to access this page.'

    sign_in users(:gardener)
    get settings_path
    assert_redirected_to root_path
    follow_redirect!
    assert_select 'div.alert', 'You are not authorized to access this page.'

    sign_in users(:maid)
    get settings_path
    assert_redirected_to root_path
    follow_redirect!
    assert_select 'div.alert', 'You are not authorized to access this page.'
  end

  test 'users' do
    sign_in users(:admin)
    get users_path
    assert_response :success

    sign_in users(:manager)
    get users_path
    assert_response :success

    sign_in users(:owner)
    get users_path
    assert_redirected_to root_path
    follow_redirect!
    assert_select 'div.alert', 'You are not authorized to access this page.'

    sign_in users(:tenant)
    get users_path
    assert_redirected_to root_path
    follow_redirect!
    assert_select 'div.alert', 'You are not authorized to access this page.'

    sign_in users(:owner_tenant)
    get users_path
    assert_redirected_to root_path
    follow_redirect!
    assert_select 'div.alert', 'You are not authorized to access this page.'

    sign_in users(:maid)
    get users_path
    assert_redirected_to root_path
    follow_redirect!
    assert_select 'div.alert', 'You are not authorized to access this page.'

    sign_in users(:gardener)
    get users_path
    assert_redirected_to root_path
    follow_redirect!
    assert_select 'div.alert', 'You are not authorized to access this page.'
  end

  # Invatation was turned off because use Devise reset password option
  # test 'invatations' do
  #   sign_in users(:admin)
  #   get new_user_invitation_path
  #   assert_response :success

  #   sign_in users(:manager)
  #   get new_user_invitation_path
  #   assert_redirected_to root_path
  #   follow_redirect!
  #   assert_select 'div.alert', 'You are not authorized to access this page.'

  #   post user_invitation_path params: {user: {email: 'test10@test.com'}}
  #   assert_redirected_to root_path
  #   follow_redirect!
  #   assert_select 'div.alert', 'You are not authorized to access this page.'

  #   sign_in users(:owner)
  #   get new_user_invitation_path
  #   assert_redirected_to root_path
  #   follow_redirect!
  #   assert_select 'div.alert', 'You are not authorized to access this page.'

  #   post user_invitation_path params: {user: {email: 'test10@test.com'}}
  #   assert_redirected_to root_path
  #   follow_redirect!
  #   assert_select 'div.alert', 'You are not authorized to access this page.'

  #   sign_in users(:tenant)
  #   get new_user_invitation_path
  #   assert_redirected_to root_path
  #   follow_redirect!
  #   assert_select 'div.alert', 'You are not authorized to access this page.'

  #   post user_invitation_path params: {user: {email: 'test10@test.com'}}
  #   assert_redirected_to root_path
  #   follow_redirect!
  #   assert_select 'div.alert', 'You are not authorized to access this page.'

  #   sign_in users(:owner_tenant)
  #   get new_user_invitation_path
  #   assert_redirected_to root_path
  #   follow_redirect!
  #   assert_select 'div.alert', 'You are not authorized to access this page.'

  #   post user_invitation_path params: {user: {email: 'test10@test.com'}}
  #   assert_redirected_to root_path
  #   follow_redirect!
  #   assert_select 'div.alert', 'You are not authorized to access this page.'

  # end

  test "user destroy jobs" do
    manager = users(:manager)
    admin = users(:admin)
    ability = Ability.new(manager)
    assert ability.can?(:destroy, Job.new(creator: manager))
    assert ability.can?(:destroy, Job.new(creator: admin))
  end

  test 'Bookings (inner)' do
    sign_in users(:admin)
    get bookings_path
    assert_response :success

    sign_in users(:manager)
    get bookings_path
    assert_response :success

    sign_in users(:owner)
    get bookings_path
    assert_redirected_to root_path
    follow_redirect!
    assert_select 'div.alert', 'You are not authorized to access this page.'

    sign_in users(:tenant)
    get bookings_path
    assert_redirected_to root_path
    follow_redirect!
    assert_select 'div.alert', 'You are not authorized to access this page.'

    sign_in users(:owner_tenant)
    get bookings_path
    assert_redirected_to root_path
    follow_redirect!
    assert_select 'div.alert', 'You are not authorized to access this page.'

    sign_in users(:maid)
    get bookings_path
    assert_redirected_to root_path
    follow_redirect!
    assert_select 'div.alert', 'You are not authorized to access this page.'

    sign_in users(:maid)
    get bookings_path
    assert_redirected_to root_path
    follow_redirect!
    assert_select 'div.alert', 'You are not authorized to access this page.'
  end

  # test 'Bookings (front)' do
  #   sign_in users(:admin)
  #   owner = users(:owner)
  #   house = houses(:villa_1)

  #   get bookings_front_path([oid: owner.id])
  #   assert_response :success

  #   sign_in users(:manager)
  #   get bookings_front_path([hid: house.number])
  #   assert_response :success

  # end

  test 'Balance' do
    # owner can see only his own balance
    sign_in users(:owner)
    get balance_front_path, params: { from: '2019-09-01', to: '2019-09-30' }
    assert_select 'tr.trsc_row', 2
    assert_select 'td.de_ow_cell', text: '80,000.00', count: 1
    assert_select 'td.cr_ow_cell', text: '2,200.99', count: 1
    assert_select 'td.cr_ow_cell', text: '16,050.00', count: 0 # owner_2
    assert_select 'td.de_ow_cell', text: '38,000.00', count: 0 # owner_2
    assert_select 'td.de_ow_cell', text: '40,000.00', count: 0 # owner_2
    assert_select 'td.cr_ow_cell', text: '5,000.00', count: 0 # company

    sign_in users(:owner_2)
    get balance_front_path, params: { from: '2019-09-01', to: '2019-09-30' }
    assert_select 'tr.trsc_row', 3
    assert_select 'td.de_ow_cell', text: '80,000.00', count: 0
    assert_select 'td.cr_ow_cell', text: '2,200.99', count: 0
    assert_select 'td.cr_ow_cell', text: '16,050.00', count: 1 # owner_2
    assert_select 'td.de_ow_cell', text: '38,000.00', count: 1 # owner_2
    assert_select 'td.de_ow_cell', text: '40,000.00', count: 1 # owner_2
    assert_select 'td.cr_ow_cell', text: '5,000.00', count: 0 # company

    # Owner can not see edit links
    assert_select 'a', text: 'Edit', count: 0
    assert_select 'a', text: 'Delete', count: 0

    # Owner can not see comment inner
    assert_no_match 'Hidden comment', response.body
  end

  test 'Transaction files' do
    # owner can see only files that allowed to see
    sign_in users(:owner)
    get balance_front_path, params: { from: '2019-09-01', to: '2019-09-30' }
    trsc1 = transactions(:one)
    trsc2 = transactions(:two)
    # trsc 1 have 3 files 1 for show
    assert_select "a[data-show-files][data-transaction=#{trsc1.id}]", text: 'Files(1)'
    # trsc 2 have 2 files 2 for show
    assert_select "a[data-show-files][data-transaction=#{trsc2.id}]", text: 'Files(2)'

    # transaction files request return only file that for show
    # trsc 1
    get transaction_files_path(transaction_id: trsc1.id), xhr: true
    files_for_show = trsc1.files.where(show: true)
    files_for_show.each do |f|
      assert_match f.url, @response.body
    end
    files_inner = trsc1.files.where(show: false)
    files_inner.each do |f|
      assert_no_match f.url, @response.body
    end

    # transaction files request return only file that for show
    # trsc 2
    get transaction_files_path(transaction_id: trsc2.id), xhr: true
    # transaction files request return only file that for show
    # trsc 1
    files_for_show = trsc2.files.where(show: true)
    files_for_show.each do |f|
      assert_match f.url, @response.body
    end
    files_inner = trsc2.files.where(show: false)
    files_inner.each do |f|
      assert_no_match f.url, @response.body
    end
  end

  test 'transactions aka balance' do
    sign_in users(:manager)
    get transactions_path
    assert_response :success
    @transaction = transactions(:one)
    assert_no_difference('Transaction.count') do
      delete transaction_url(@transaction)
    end
    assert_redirected_to root_path
    follow_redirect!
    assert_select 'div.alert', 'You are not authorized to access this page.'

    sign_in users(:tenant)
    get transactions_path
    assert_redirected_to root_path
    follow_redirect!
    assert_select 'div.alert', 'You are not authorized to access this page.'

    # Manager and Accounting can edit only until 1st of previous month
    sign_in users(:accounting)
    # old transaction
    @transaction = transactions(:prev_3)
    patch transaction_url(@transaction), params: {
      transaction: {
        date: @transaction.date,
        comment_en: @transaction.comment_en,
        comment_inner: @transaction.comment_inner,
        comment_ru: @transaction.comment_ru,
        house_id: @transaction.house_id,
        ref_no: @transaction.ref_no,
        type_id: @transaction.type_id,
        user_id: @transaction.user_id
      }
    }
    assert_redirected_to root_path
    follow_redirect!
    assert_select 'div.alert', 'You are not authorized to access this page.'
    sign_out :user

    sign_in users(:manager)
    @transaction = transactions(:prev_3)
    patch transaction_url(@transaction), params: {
      transaction: {
        date: @transaction.date,
        comment_en: @transaction.comment_en,
        comment_inner: @transaction.comment_inner,
        comment_ru: @transaction.comment_ru,
        house_id: @transaction.house_id,
        ref_no: @transaction.ref_no,
        type_id: @transaction.type_id,
        user_id: @transaction.user_id
      }
    }
    assert_redirected_to root_path
    follow_redirect!
    assert_select 'div.alert', 'You are not authorized to access this page.'
    sign_out :user

    # upload transaction that happened 10 days ago
    sign_in users(:accounting)
    get transactions_path
    type = TransactionType.find_by(name_en: 'Utilities')
    house = houses(:villa_1)
    assert_difference('Transaction.count', 1) do
      post transactions_path, params: {
        transaction: {
          date: 10.days.ago,
          type_id: type.id,
          house_id: house.id,
          cr_ow: 3500,
          comment_en: 'Electricity 08.2019'
        }
      }
    end
    new_transaction = Transaction.last
    # accounting can edit
    patch transaction_url(new_transaction), params: {
      transaction: {
        cr_ow: 3500,
        comment_en: 'New comment_en',
        comment_inner: 'New comment_inner',
        comment_ru: 'New comment_ru',
        house_id: new_transaction.house_id,
        ref_no: new_transaction.ref_no,
        type_id: new_transaction.type_id,
        user_id: new_transaction.user_id
      }
    }
    assert_redirected_to transactions_path
    follow_redirect!
    assert_select 'div.alert', 'Transaction was successfully updated.'
    sign_out :user

    # manager can edit
    sign_in users(:manager)
    get transactions_path
    patch transaction_url(new_transaction), params: {
      transaction: {
        cr_ow: 3500,
        comment_en: 'New comment_en',
        comment_inner: 'New comment_inner',
        comment_ru: 'New comment_ru',
        house_id: new_transaction.house_id,
        ref_no: new_transaction.ref_no,
        type_id: new_transaction.type_id,
        user_id: new_transaction.user_id
      }
    }
    assert_redirected_to transactions_path
    follow_redirect!
    assert_select 'div.alert', 'Transaction was successfully updated.'
    sign_out :user

    # Manager and Accounting can edit only with in 1 day

    # create transaction that happened 2 days ago
    sign_in users(:accounting)
    get transactions_path
    type = TransactionType.find_by(name_en: 'Utilities')
    house = houses(:villa_1)
    assert_difference('Transaction.count', 1) do
      post transactions_path, params: {
        transaction: {
          date: Time.current - 2.days,
          type_id: type.id,
          house_id: house.id,
          cr_ow: 3500,
          comment_en: 'Electricity 08.2019'
        }
      }
    end
    new_transaction = Transaction.last
    # accounting can not delete
    assert_no_difference('Transaction.count') do
      delete transaction_url(new_transaction)
    end
    assert_redirected_to root_path
    follow_redirect!
    assert_select 'div.alert', 'You are not authorized to access this page.'
    sign_out :user
    # manager can not delete
    sign_in users(:accounting)
    assert_no_difference('Transaction.count') do
      delete transaction_url(new_transaction)
    end
    assert_redirected_to root_path
    follow_redirect!
    assert_select 'div.alert', 'You are not authorized to access this page.'
    sign_out :user

    # create transaction that happened today
    sign_in users(:accounting)
    get transactions_path
    type = TransactionType.find_by(name_en: 'Utilities')
    house = houses(:villa_1)
    assert_difference('Transaction.count', 1) do
      post transactions_path, params: {
        transaction: {
          date: Time.current,
          type_id: type.id,
          house_id: house.id,
          cr_ow: 3500,
          comment_en: 'Electricity 08.2019'
        }
      }
    end
    new_transaction = Transaction.last
    # accounting can delete
    assert_difference('Transaction.count', -1) do
      delete transaction_url(new_transaction)
    end
    assert_redirected_to transactions_path
    follow_redirect!
    assert_select 'div.alert', 'Transaction was successfully destroyed.'
    sign_out :user

    # create transaction that happened today
    sign_in users(:accounting)
    get transactions_path
    type = TransactionType.find_by(name_en: 'Utilities')
    house = houses(:villa_1)
    assert_difference('Transaction.count', 1) do
      post transactions_path, params: {
        transaction: {
          date: Time.current,
          type_id: type.id,
          house_id: house.id,
          cr_ow: 3500,
          comment_en: 'Electricity 08.2019'
        }
      }
    end
    new_transaction = Transaction.last
    # manager can delete
    sign_in users(:accounting)
    assert_difference('Transaction.count', -1) do
      delete transaction_url(new_transaction)
    end
    assert_redirected_to transactions_path
    follow_redirect!
    assert_select 'div.alert', 'Transaction was successfully destroyed.'
    sign_out :user
  end

  test 'documents' do
    trsc = Transaction.where(comment_en: 'rental').first.id
    get tmp_reimbersment_path, params: { locale: 'en', trsc_id: trsc }
    assert_redirected_to root_path
    follow_redirect!
    assert_select 'div.alert', 'You are not authorized to access this page.'

    sign_in users(:admin)
    get tmp_reimbersment_path, params: { locale: 'en', trsc_id: trsc }
    assert_response :success

    sign_in users(:accounting)
    get tmp_reimbersment_path, params: { locale: 'en', trsc_id: trsc }
    assert_response :success

    sign_in users(:manager)
    get tmp_reimbersment_path, params: { locale: 'en', trsc_id: trsc }
    assert_redirected_to root_path
    follow_redirect!
    assert_select 'div.alert', 'You are not authorized to access this page.'

    sign_in users(:owner)
    get tmp_reimbersment_path, params: { locale: 'en', trsc_id: trsc }
    assert_redirected_to root_path
    follow_redirect!
    assert_select 'div.alert', 'You are not authorized to access this page.'
  end

  test "should show balance closed checkbox" do
    owner = users(:owner)
    manager = users(:manager)
    accounting = users(:accounting)
    sign_in users(:admin)
    get edit_user_path(owner.id)
    assert_response :success
    assert_match "Balance closed", response.body
    get edit_user_path(manager.id)
    assert_response :success
    assert_no_match "Balance closed", response.body
    get edit_user_path(accounting.id)
    assert_response :success
    assert_no_match "Balance closed", response.body
    sign_out users(:admin)
  end

  test "should update balance closed" do
    owner = users(:owner)
    sign_in users(:admin)
    put "/users/#{owner.id}", params: { user: { balance_closed: '1' } }
    assert_redirected_to users_path
    assert User.find(owner.id).balance_closed
    follow_redirect!
    assert_select 'div.alert li', text: 'Successfully updated User.'
  end

  test "reports" do
    # Maager can not see salary reports
    sign_in users(:manager)
    get reports_path
    assert_response :success
    assert_select 'a', { text: 'Salary', count: 0 }
    get report_bookings_path
    assert_response :success
    get report_salary_path
    assert_redirected_to root_path
    follow_redirect!
    assert_select 'div.alert', 'You are not authorized to access this page.'
  end
end
