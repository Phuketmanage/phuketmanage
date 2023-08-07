class Transfer < ApplicationRecord
  enum trsf_type: { IN: 0, OUT: 1 }
  enum status: { sent: 0, confirmed: 1, amended: 2, canceling: 3, canceled: 4 }

  belongs_to :booking, optional: :true
end
