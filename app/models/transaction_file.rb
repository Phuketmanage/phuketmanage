class TransactionFile < ApplicationRecord
  the_schema_is "transaction_files" do |t|
    t.bigint "trsc_id", null: false
    t.string "url", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "show", default: false
  end

  belongs_to :trsc, class_name: "Transaction"
  validates :url, presence: true
  after_destroy :delete_file_from_s3

  def full_url
    return "#{S3_HOST}#{url}"
  end

  private
    def delete_file_from_s3
      S3_BUCKET.object(url).delete
    end

end
