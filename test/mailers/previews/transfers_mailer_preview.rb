# Preview all emails at http://localhost:3000/rails/mailers/transfers_mailer
class TransfersMailerPreview < ActionMailer::Preview


  # Preview this email at http://localhost:3000/rails/mailers/transfers_mailer/created
  def created
    transfer = Transfer.find_by(number: "PY01N3M")
    TransfersMailer.created(transfer)
  end

  def amended
    transfer = Transfer.find_by(number: "W78BVYU")
    transfer.trsf_type == "ARR" ? transfer.trsf_type = "DEP" : transfer.trsf_type = "ARR"
    transfer.date = transfer.date+1.day
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


  # Preview this email at http://localhost:3000/rails/mailers/transfers_mailer/confirmed
  def confirmed
    TransfersMailer.confirmed
  end

  # Preview this email at http://localhost:3000/rails/mailers/transfers_mailer/canceled
  def canceled
    TransfersMailer.canceled
  end

end
