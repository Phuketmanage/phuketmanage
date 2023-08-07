# == Schema Information
#
# Table name: employees
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  type_id    :bigint           not null
#
# Indexes
#
#  index_employees_on_type_id  (type_id)
#
# Foreign Keys
#
#  fk_rails_...  (type_id => empl_types.id)
#
require 'test_helper'

class EmployeeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
