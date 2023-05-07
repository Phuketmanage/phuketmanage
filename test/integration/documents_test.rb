require 'test_helper'

class DocumentsTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @house = houses(:villa_1)
    @owner = @house.owner
    @booking = bookings(:_1)
    @type = transaction_types(:rental)
  end

  test 'print button should be disabled' do
    sign_in users(:admin)
    assert_difference('Transaction.count', 1) do
      post transactions_path, params: {
        transaction: {
          ref_no: "",
          house_id: @house.id,
          type_id: @type.id,
          user_id: @owner.id,
          comment_en: "Rental 15.5.2022 - 5.6.2022",
          comment_ru: "Аренда 15.5.2022 - 5.6.2022",
          comment_inner: "",
          date: "2022-04-28",
          booking_id: @booking.id,
          hidden: false,
          for_acc: false,
          incomplite: false,
          cash: false,
          transfer: false
        }
      }
    end
    get "/documents/reimbersment", params: {trsc_id: Transaction.last.id}
    assert_response :success
    assert_select "#rb_print[disabled=disabled]", 1
    sign_out users(:admin)
  end
end
