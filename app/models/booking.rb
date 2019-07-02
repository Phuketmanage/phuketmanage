class Booking < ApplicationRecord
  enum status:  {
    temporary: 0,
    pending: 1,
    confirmed: 2,
    paid: 3,
    canceled: 4,
    changing: 5,
    block: 6 }
  belongs_to :house
  belongs_to :tenant, class_name: 'User'


  def get_available_houses rs, rf
    overlapped_bookings = Booking.where(
      'start < ? AND finish > ? AND status != ?', rf, rs,
      Booking.statuses[:canceled]).all.map{
      |b| {house_id: b.house_id, start: b.start, finish: b.finish}}
    booked_house_ids = overlapped_bookings.map{|b| b[:house_id]}
    if booked_house_ids.any?
      available_houses = House.where.not(id: booked_house_ids)
    else
      available_houses = House.all
    end

  end

end
