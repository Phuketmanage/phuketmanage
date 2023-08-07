# == Schema Information
#
# Table name: sources
#
#  id         :bigint           not null, primary key
#  name       :string
#  syncable   :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_sources_on_syncable  (syncable)
#
require 'test_helper'

class SourceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
