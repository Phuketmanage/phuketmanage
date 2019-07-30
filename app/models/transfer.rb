class Transfer < ApplicationRecord
  enum trsf_type: [:IN, :OUT]
  enum status: [:sent, :confirmed, :amended, :canceled]

  belongs_to :booking, optional: :true
end
