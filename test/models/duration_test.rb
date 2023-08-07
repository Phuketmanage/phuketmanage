# == Schema Information
#
# Table name: durations
#
#  id         :bigint           not null, primary key
#  finish     :integer
#  start      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  house_id   :bigint           not null
#
# Indexes
#
#  index_durations_on_house_id  (house_id)
#
# Foreign Keys
#
#  fk_rails_...  (house_id => houses.id)
#
require 'test_helper'

class DurationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
