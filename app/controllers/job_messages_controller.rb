class JobMessagesController < ApplicationController
  load_and_authorize_resource

  def create

    job = Job.find(params['job_id'])
    @message = job.job_messages.new(job_message_params)
    @message.sender_id = current_user.id
      if @message.save
      else
        redirect_to jobs_path
      end

  end

  def destroy
    @message = JobMessage.find(params['id'])
    S3_BUCKET.object(@message.message).delete
    @message.destroy
  end

  private
    def job_message_params
      params.require(:job_message).permit(:message, :file)
    end


end
