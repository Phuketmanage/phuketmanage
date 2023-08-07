# == Schema Information
#
# Table name: water_usages
#
#  id         :bigint           not null, primary key
#  amount     :integer
#  amount_2   :integer
#  comment    :string
#  date       :date
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  house_id   :bigint           not null
#
# Indexes
#
#  index_water_usages_on_house_id  (house_id)
#
# Foreign Keys
#
#  fk_rails_...  (house_id => houses.id)
#
require 'test_helper'

class WaterUsageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
