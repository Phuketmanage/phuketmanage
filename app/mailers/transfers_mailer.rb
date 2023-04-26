class TransfersMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.transfers_mailer.created.subject
  #
  def created(transfer)
    @transfer = transfer
    @changes = {}
    I18n.with_locale(:en) do
      mail to: @settings["tranfer_supplier_email"],
           subject: "New transfer - #{transfer.trsf_type} #{transfer.date.strftime('%d.%m.%Y')}"
    end
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.transfers_mailer.amended.subject
  #

  def amended(transfer, changes)
    @transfer = transfer
    @changes = changes
    I18n.with_locale(:en) do
      mail to: @settings["tranfer_supplier_email"],
           subject: "Transfer amended - #{transfer.trsf_type} #{transfer.date.strftime('%d.%m.%Y')}"
    end
  end

  def canceled(transfer)
    @transfer = transfer
    @changes = {}
    I18n.with_locale(:en) do
      mail to: @settings["tranfer_supplier_email"],
           subject: "Transfer canceled - #{transfer.trsf_type} #{transfer.date.strftime('%d.%m.%Y')}"
    end
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.transfers_mailer.cancelled.subject
  #
end
