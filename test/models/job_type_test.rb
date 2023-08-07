# == Schema Information
#
# Table name: job_types
#
#  id             :bigint           not null, primary key
#  code           :string
#  color          :string
#  for_house_only :boolean
#  name           :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
require 'test_helper'

class JobTypeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
