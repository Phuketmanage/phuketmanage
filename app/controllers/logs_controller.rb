class LogsController < ApplicationController
  load_and_authorize_resource
  layout 'admin'

  def index
    @logs = Log.all.order(when: :desc)
  end
end
