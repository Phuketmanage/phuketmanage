class Notification < ApplicationRecord
  belongs_to :house, optional: true
end
