class Admin::TransactionFilesController < AdminController
  verify_authorized

  # @route GET /transaction_files (transaction_files)
  def index
    authorize!
    if current_user.role? %w[Owner]
      files = Transaction.find(params[:transaction_id]).files.where(show: true)
    elsif current_user.role? %w[Manager Accounting Admin]
      files = Transaction.find(params[:transaction_id]).files
    end  
    render json: { files: files }
  end

  # @route DELETE /transaction_file (transaction_file)
  def destroy
    authorize!
    @file = TransactionFile.find(params['id'])
    @file.destroy
  end

  # @route DELETE /transaction_file_tmp (transaction_file_tmp)
  def destroy_tmp
    authorize!
    key = params['key']
    S3_BUCKET.object(key).delete
    render json: { key: key }
  end

  # @route GET /transaction_file_toggle_show (transaction_file_toggle_show)
  def toggle_show
    authorize!
    file = TransactionFile.where(id: params[:id]).first
    if file.present?
      file.update(show: params[:status]) if params[:status].present?
      render json: { id: file.id }
    else
      render json: { id: params[:id], success: false }, status: :bad_request
    end
  end

  # @route GET /transaction_file_download (transaction_file_download)
  def download
    authorize!
    key = params['key']
    file = S3_CLIENT.get_object(
      response_target: File.basename(key),
      bucket: ENV.fetch('S3_BUCKET', nil),
      key: key
    )
    file = open(file.body)
    respond_to do |format|
      format.js { send_file file }
    end

    # S3_BUCKET.object(key)
    # url_options = {
    #   expires_in:                   5.minutes,
    #   use_ssl:                      true,
    #   response_content_disposition: "attachment; filename=\"#{File.basename(key)}\""
    # }
  end
end
