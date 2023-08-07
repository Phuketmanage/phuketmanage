# == Schema Information
#
# Table name: house_options
#
#  id         :bigint           not null, primary key
#  comment_en :string
#  comment_ru :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  house_id   :bigint           not null
#  option_id  :bigint           not null
#
# Indexes
#
#  index_house_options_on_house_id   (house_id)
#  index_house_options_on_option_id  (option_id)
#
# Foreign Keys
#
#  fk_rails_...  (house_id => houses.id)
#  fk_rails_...  (option_id => options.id)
#
require 'test_helper'

class HouseOptionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
