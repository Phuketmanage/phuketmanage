# == Schema Information
#
# Table name: house_photos
#
#  id         :bigint           not null, primary key
#  position   :integer
#  title_en   :string
#  title_ru   :string
#  url        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  house_id   :bigint           not null
#
# Indexes
#
#  index_house_photos_on_house_id  (house_id)
#
# Foreign Keys
#
#  fk_rails_...  (house_id => houses.id)
#
require 'test_helper'

class HousePhotoTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
