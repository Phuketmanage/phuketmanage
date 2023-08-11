# == Schema Information
#
# Table name: uploads_tests
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# TODO: Remove after #353

class UploadsTest < ApplicationRecord
  has_many_attached :images
end
