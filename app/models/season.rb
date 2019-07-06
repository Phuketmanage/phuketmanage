class Season < ApplicationRecord
  belongs_to :house
  validates :ssd, :ssm, :sfd, :sfm, presence: true
  validates :ssm, :sfm, :numericality => {
    greater_than: 0,
    less_than: 13
  }
  validates :ssd, :sfd, :numericality => {
    greater_than: 0,
    less_than: 32
  }
end
