# == Schema Information
#
# Table name: prices
#
#  id          :bigint           not null, primary key
#  amount      :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  duration_id :integer
#  house_id    :bigint           not null
#  season_id   :integer
#
# Indexes
#
#  index_prices_on_duration_id  (duration_id)
#  index_prices_on_house_id     (house_id)
#  index_prices_on_season_id    (season_id)
#
# Foreign Keys
#
#  fk_rails_...  (house_id => houses.id)
#
require 'test_helper'

class PriceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
