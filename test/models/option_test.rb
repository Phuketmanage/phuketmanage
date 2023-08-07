# == Schema Information
#
# Table name: options
#
#  id         :bigint           not null, primary key
#  title_en   :string
#  title_ru   :string
#  zindex     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'test_helper'

class OptionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
