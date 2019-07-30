class Transfer < ApplicationRecord
  enum trsf_type: [:IN, :OUT]
  enum status: [:sent, :confirmed, :amended, :canceling, :canceled]

  belongs_to :booking, optional: :true
end
