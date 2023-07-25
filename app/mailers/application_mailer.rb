class ApplicationMailer < ActionMailer::Base
  before_action :set_settings
  layout 'mailer'

  default from: 'Phuket Manage <info@phuketmanage.com>'

  private

  def set_settings
    @settings = Setting.all.to_h { |s| [s.var, s.value] }
  end
end
