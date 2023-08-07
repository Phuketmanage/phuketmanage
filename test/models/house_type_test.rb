# == Schema Information
#
# Table name: house_types
#
#  id         :bigint           not null, primary key
#  comm       :integer
#  name_en    :string
#  name_ru    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'test_helper'

class HouseTypeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
