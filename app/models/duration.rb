# == Schema Information
#
# Table name: durations
#
#  id         :bigint           not null, primary key
#  finish     :integer
#  start      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  house_id   :bigint           not null
#
# Indexes
#
#  index_durations_on_house_id  (house_id)
#
# Foreign Keys
#
#  fk_rails_...  (house_id => houses.id)
#
class Duration < ApplicationRecord
  belongs_to :house
  validates :start, :finish, numericality: {
    greater_than: 0,
    less_than: 366
  }

  validate :not_overlapped

  def not_overlapped
    durations = House.find(house_id).durations
    overlapped = durations.where('start <= ? AND finish >= ?', finish, start)
    return unless overlapped.any?

    errors.add(:base,
               "There is at least one duration that overlapped with newly created duration period, need to change start or finish")
  end
end
