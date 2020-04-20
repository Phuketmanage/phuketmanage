class TransactionFilesController < ApplicationController
  load_and_authorize_resource

  def destroy
    @file = TransactionFile.find(params['id'])
    @file.destroy
  end

  def destroy_tmp
    key = params['key']
    S3_BUCKET.object(key).delete
    render json: {key: key}
  end


end
