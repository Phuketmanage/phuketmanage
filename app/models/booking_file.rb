class BookingFile < ApplicationRecord
  belongs_to :booking
  belongs_to :user, optional: true
  after_destroy :delete_file_from_s3

  def full_url
    return "#{S3_HOST}#{url}"
  end

  private
    def delete_file_from_s3
      S3_BUCKET.object(url).delete
    end

end
