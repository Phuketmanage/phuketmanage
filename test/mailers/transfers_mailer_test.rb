require 'test_helper'

class TransfersMailerTest < ActionMailer::TestCase
  test "created" do
    mail = TransfersMailer.created
    assert_equal "Created", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "confirmed" do
    mail = TransfersMailer.confirmed
    assert_equal "Confirmed", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "amended" do
    mail = TransfersMailer.amended
    assert_equal "Amended", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "cancelled" do
    mail = TransfersMailer.cancelled
    assert_equal "Cancelled", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
