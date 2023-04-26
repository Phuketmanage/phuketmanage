require 'test_helper'

class TransfersMailerTest < ActionMailer::TestCase
  setup do
    @transfer = transfers(:one)
    @changes = {}
    @settings = Setting.all.map { |s| [s.var, s.value] }.to_h
  end

  test "created" do
    mail = TransfersMailer.created(@transfer)
    assert_equal "New transfer - #{@transfer.trsf_type} #{@transfer.date.strftime('%d.%m.%Y')}", mail.subject
    assert_equal [@settings["tranfer_supplier_email"]], mail.to
    assert_equal ["info@phuketmanage.com"], mail.from
    assert_match "Transfer details:", mail.body.encoded
  end

  test "amended" do
    mail = TransfersMailer.amended(@transfer, @changes)
    assert_equal "Transfer amended - #{@transfer.trsf_type} #{@transfer.date.strftime('%d.%m.%Y')}", mail.subject
    assert_equal [@settings["tranfer_supplier_email"]], mail.to
    assert_equal ["info@phuketmanage.com"], mail.from
    assert_match "Transfer details:", mail.body.encoded
  end

  test "cancedled" do
    mail = TransfersMailer.canceled(@transfer)
    assert_equal "Transfer canceled - #{@transfer.trsf_type} #{@transfer.date.strftime('%d.%m.%Y')}", mail.subject
    assert_equal [@settings["tranfer_supplier_email"]], mail.to
    assert_equal ["info@phuketmanage.com"], mail.from
    assert_match "Transfer details:", mail.body.encoded
  end
end
