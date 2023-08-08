class JobMessagesController < ApplicationController
  load_and_authorize_resource

  # @route POST (/:locale)/job_messages {locale: nil} (job_messages)
  def create
    job = Job.find(params['job_id'])
    @message = job.job_messages.new(job_message_params)
    @message.sender_id = current_user.id
    if @message.save
      job.update(updated_at: Time.current)
      job.job_tracks.where(user_id: current_user.id).update(visit_time: Time.current)
    else
      redirect_to jobs_path
    end
  end

  # @route DELETE (/:locale)/job_message {locale: nil} (job_message)
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
