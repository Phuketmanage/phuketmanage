class ApplicationMailer < ActionMailer::Base
  before_action :set_settings
  layout 'mailer'

  default from: 'info@phuketmanage.com'

  private
    def set_settings
      @settings = Setting.all.map{|s| [s.var, s.value]}.to_h
    end
end
