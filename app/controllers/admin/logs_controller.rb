class Admin::LogsController < ApplicationController
  load_and_authorize_resource
  layout 'admin'

  # @route GET /logs (logs)
  def index
    @logs = Log.all.order(created_at: :desc)
  end
end
