require 'test_helper'

class BookingMailerTest < ActionMailer::TestCase
  setup do
    @booking = bookings(:_1)
    @settings = Setting.all.to_h { |s| [s.var, s.value] }
  end

  test "created" do
    mail = BookingMailer.created(@booking)
    assert_equal "New booking for #{@booking.house.code}: #{@booking.start.strftime('%d.%m.%Y')} - #{@booking.finish.strftime('%d.%m.%Y')}",
                 mail.subject
    assert_equal ["rent@phuketmanage.com"], mail.to
    assert_equal ["info@phuketmanage.com"], mail.from
    assert_match "Open bookings for #{@booking.house.code}", mail.body.encoded
  end
end
