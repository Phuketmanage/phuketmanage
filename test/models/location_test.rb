# == Schema Information
#
# Table name: locations
#
#  id         :bigint           not null, primary key
#  descr_en   :text
#  descr_ru   :text
#  name_en    :string
#  name_ru    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'test_helper'

class LocationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
