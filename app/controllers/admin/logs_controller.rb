class Admin::LogsController < AdminController
  load_and_authorize_resource

  # @route GET /logs (logs)
  def index
    @logs = Log.all.order(created_at: :desc)
  end
end
