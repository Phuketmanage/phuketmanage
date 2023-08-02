class ErrorsController < ApplicationController
  def not_found
    respond_to do |format|
      format.html { render status: :not_found }
      format.any { head :not_found, content_type: 'text/plain' }
    end
  end

  def unprocessable_content
    respond_to do |format|
      format.html { render status: :unprocessable_content }
      format.any { head :unprocessable_content, content_type: 'text/plain' }
    end
  end

  def internal_server_error
    respond_to do |_format|
      format.html { render status: :internal_server_error }
      format.any { head :internal_server_error, content_type: 'text/plain' }
    end
  end
end
