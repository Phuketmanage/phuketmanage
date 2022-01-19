class TransactionFile < ApplicationRecord
  belongs_to :trsc, class_name: "Transaction"
  validates :url, presence: true
  after_destroy :delete_file_from_s3

  def full_url
    return "#{S3_HOST}#{url}"
  end

  def download_url
    return "#{S3_HOST_SHORT}#{url}"
  end

  def download_url_2
    file = S3_CLIENT.get_object(
      response_target: '1',
      bucket: ENV['S3_BUCKET'],
      key: url
    )
    file.body
    # send_file 'utl'
    #s3.bucket('bucket-name').object('key').get(response_target: '/path/to/file')
  end

  private
    def delete_file_from_s3
      S3_BUCKET.object(url).delete
    end

end
