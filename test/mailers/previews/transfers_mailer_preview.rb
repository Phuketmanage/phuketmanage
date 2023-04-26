# Preview all emails at http://localhost:3000/rails/mailers/transfers_mailer
class TransfersMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/transfers_mailer/created
  def created
    transfer = Transfer.find_by(number: "4Q3YIOU")
    TransfersMailer.created(transfer)
  end

  def amended
    transfer = Transfer.find_by(number: "AG05XIY")
    transfer.trsf_type = (transfer.trsf_type == "IN" ? "OUT" : "IN")
    transfer.date = transfer.date + 1.day
    transfer.time = transfer.time.split("").shuffle.join
    transfer.from = "New from".split("").shuffle.join
    transfer.client = "New name".split("").shuffle.join
    transfer.pax = "2+3".split("").shuffle.join
    transfer.to = "International terminal".split("").shuffle.join
    transfer.remarks = "COT1200".split("").shuffle.join
    changes = transfer.changes
    transfer.save
    TransfersMailer.amended(transfer, changes)
  end

  # Preview this email at http://localhost:3000/rails/mailers/transfers_mailer/canceled
  def canceled
    transfer = Transfer.find_by(number: "XDZWPL9")
    TransfersMailer.canceled(transfer)
  end
end
