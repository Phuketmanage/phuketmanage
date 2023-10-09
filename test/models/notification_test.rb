# == Schema Information
#
# Table name: notifications
#
#  id         :bigint           not null, primary key
#  level      :string
#  text       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  house_id   :bigint
#
# Indexes
#
#  index_notifications_on_house_id  (house_id)
#
# Foreign Keys
#
#  fk_rails_...  (house_id => houses.id)
#
require 'test_helper'

class NotificationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
