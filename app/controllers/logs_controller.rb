class LogsController < ApplicationController
  load_and_authorize_resource
  layout 'admin'

  # @route GET /logs (logs)
  def index
    @logs = Log.all.order(when: :desc)
  end
end
