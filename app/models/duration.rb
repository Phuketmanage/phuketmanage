class Duration < ApplicationRecord
  belongs_to :house
  validates :start, :finish, :numericality => {
    greater_than: 0,
    less_than: 366 }

  validate :not_overlapped

  def not_overlapped
    durations = House.find(house_id).durations
    overlapped = durations.where('start <= ? AND finish >= ?', finish, start)
    errors.add(:base, "There is at least one duration that overlapped with newly created duration period, need to change start or finish") if overlapped.any?
  end

end
