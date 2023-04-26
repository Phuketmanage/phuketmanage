class BookingMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.booking_mailer.created.subject
  #
  def created(booking)
    @booking = booking
    I18n.with_locale(:en) do
      mail to: 'rent@phuketmanage.com',
           subject: "New booking for #{@booking.house.code}: #{booking.start.strftime('%d.%m.%Y')} - #{booking.finish.strftime('%d.%m.%Y')}"
    end
  end
end
