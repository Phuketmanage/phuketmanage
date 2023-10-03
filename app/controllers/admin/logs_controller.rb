class Admin::LogsController < AdminController
  verify_authorized

  # @route GET /logs (logs)
  def index
    authorize!
    @logs = Log.all.order(created_at: :desc)
  end
end
