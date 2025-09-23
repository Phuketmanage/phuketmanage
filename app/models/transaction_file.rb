# == Schema Information
#
# Table name: transaction_files
#
#  id         :bigint           not null, primary key
#  show       :boolean          default(FALSE)
#  url        :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  trsc_id    :bigint           not null
#
# Indexes
#
#  index_transaction_files_on_trsc_id  (trsc_id)
#
# Foreign Keys
#
#  fk_rails_...  (trsc_id => transactions.id)
#
class TransactionFile < ApplicationRecord
  belongs_to :trsc, class_name: "Transaction"
  validates :url, presence: true
  after_destroy :delete_file_from_s3

  def full_url
    "#{S3_HOST}#{url}"
  end

  private

  def delete_file_from_s3
    return unless Rails.env.production?
    S3_BUCKET.object(url).delete
  end
end
