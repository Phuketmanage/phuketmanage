# == Schema Information
#
# Table name: transaction_files
#
#  id         :bigint           not null, primary key
#  show       :boolean          default(FALSE)
#  url        :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  trsc_id    :bigint           not null
#
# Indexes
#
#  index_transaction_files_on_trsc_id  (trsc_id)
#
# Foreign Keys
#
#  fk_rails_...  (trsc_id => transactions.id)
#
require 'test_helper'

class TransactionFileTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
