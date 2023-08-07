# == Schema Information
#
# Table name: seasons
#
#  id         :bigint           not null, primary key
#  sfd        :integer
#  sfm        :integer
#  ssd        :integer
#  ssm        :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  house_id   :bigint           not null
#
# Indexes
#
#  index_seasons_on_house_id  (house_id)
#
# Foreign Keys
#
#  fk_rails_...  (house_id => houses.id)
#
require 'test_helper'

class SeasonTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
