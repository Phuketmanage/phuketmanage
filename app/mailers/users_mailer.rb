class UsersMailer < Devise::Mailer
  helper :application # gives access to all helpers defined within `application_helper`.
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`
  default template_path: 'devise/mailer' # to make sure that your mailer uses the devise views

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.transfers_mailer.created.subject
  #
  def reset_password_instructions(record, token, opts = {})
    headers["Custom-header"] = "Bar"
    opts[:from] = 'Phuket manage <info@phuketmanage.com>'
    opts[:reply_to] = 'Phuket manage <info@phuketmanage.com>'
    opts[:to] = "#{record.name} #{record.surname} <#{record.email}>"
    I18n.with_locale(record.locale ||= :en) do
      opts[:subject] = default_i18n_subject
      super
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
           subject: "Transfer amended - #{transfer.trsf_type} #{transfer.date.to_fs(:date)}"
    end
  end

  def canceled(transfer)
    @transfer = transfer
    @changes = {}
    I18n.with_locale(:en) do
      mail to: @settings["tranfer_supplier_email"],
           subject: "Transfer canceled - #{transfer.trsf_type} #{transfer.date.to_fs(:date)}"
    end
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.transfers_mailer.cancelled.subject
  #
end
