class TransfersMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.transfers_mailer.created.subject
  #
  def created(transfer)
    @transfer = transfer
    @changes = {}
    mail to:  @settings["tranfer_supplier_email"], subject: "#{transfer.trsf_type} #{transfer.date.strftime("%d.%m.%Y")}"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.transfers_mailer.amended.subject
  #

  def amended(transfer, changes)
    @transfer = transfer
    @changes = changes
    mail to:  @settings["tranfer_supplier_email"], subject: "#{transfer.trsf_type} #{transfer.date.strftime("%d.%m.%Y")} - amendment"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.transfers_mailer.cancelled.subject
  #
  def canceled
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
