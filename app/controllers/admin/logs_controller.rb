class Admin::LogsController < ApplicationController
  load_and_authorize_resource
  layout 'admin'

  # @route GET (/:locale)/logs {locale: nil} (logs)
  def index
    @logs = Log.all.order(created_at: :desc)
  end
end
