class JobMessage < ApplicationRecord
  belongs_to :job
  belongs_to :sender, class_name: "User"

  def url
    return "#{S3_HOST}#{message}"
  end

end
