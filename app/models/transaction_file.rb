class TransactionFile < ApplicationRecord
  belongs_to :trsc, class_name: "Transaction"
  validates :url, presence: true
  after_destroy :delete_file_from_s3

  def full_url
    # if Rails.env.production?
    #   return "https:#{S3_HOST}#{url}"
    # else
    #   return "http:#{S3_HOST}#{url}"
    # end
    return "#{S3_HOST}#{url}"
  end

  private
    def delete_file_from_s3
      S3_BUCKET.object(url).delete
    end

end
