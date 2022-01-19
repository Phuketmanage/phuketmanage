class TransactionFilesController < ApplicationController
  load_and_authorize_resource

  def index
    if current_user.role?(['Owner'])
      files = Transaction.find(params[:transaction_id]).files.where(show: true)
    elsif current_user.role?(['Admin', 'Accounting', 'Manager'])
      files = Transaction.find(params[:transaction_id]).files
    end
    render json: {files: files}
  end

  def destroy
    @file = TransactionFile.find(params['id'])
    @file.destroy
  end

  def destroy_tmp
    key = params['key']
    S3_BUCKET.object(key).delete
    render json: {key: key}
  end

  def toggle_show
    file = TransactionFile.where(id: params[:id]).first
    if file.present?
      file.update_attributes(show: params[:status]) if params[:status].present?
      render json: {id: file.id}
    else
      render json: {id: params[:id], success: false}, status: 400
    end
  end

  def download
    key = params['key']
    file = S3_CLIENT.get_object(
      response_target: File.basename(key),
      bucket: ENV['S3_BUCKET'],
      key: key
    )
    file = open(file.body)
    send_file file
  end

end
