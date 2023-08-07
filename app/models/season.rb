# == Schema Information
#
# Table name: seasons
#
#  id         :bigint           not null, primary key
#  sfd        :integer
#  sfm        :integer
#  ssd        :integer
#  ssm        :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  house_id   :bigint           not null
#
# Indexes
#
#  index_seasons_on_house_id  (house_id)
#
# Foreign Keys
#
#  fk_rails_...  (house_id => houses.id)
#
class Season < ApplicationRecord
  belongs_to :house
  validates :ssd, :ssm, :sfd, :sfm, presence: true
  validates :ssm, :sfm, numericality: {
    greater_than: 0,
    less_than: 13
  }
  validates :ssd, :sfd, numericality: {
    greater_than: 0,
    less_than: 32
  }
  validate :start_from_finish
  validate :not_overlapped
  validate :not_end_of_february
  validate :not_less_then_days

  def start_from_finish
    s = House.find(house_id).seasons.order(:created_at).last
    return if s.nil?

    have_error = false
    sf = (s.sfm.to_i + (s.sfd.to_f / 30)).round(2)
    nss = (ssm.to_i + (ssd.to_f / 30)).round(2)
    nsf = (sfm.to_i + (sfd.to_f / 30)).round(2)
    have_error = true if nss != sf
    errors.add(:base, "New season should start from end of last season") if have_error
  end

  def not_overlapped
    seasons = House.find(house_id).seasons
    nss = (ssm.to_i + (ssd.to_f / 30)).round(2)
    nsf = (sfm.to_i + (sfd.to_f / 30)).round(2)
    have_error = false
    seasons.each do |s|
      ss = (s.ssm.to_i + (s.ssd.to_f / 30)).round(2)
      sf = (s.sfm.to_i + (s.sfd.to_f / 30)).round(2)
      if ss < sf && nss < nsf
        have_error = true if ss < nsf && sf > nss
        details = "#{s.ssd}.#{s.ssm}-#{s.sfd}.#{s.sfm}, sub test 1"
      elsif ss > sf
        have_error = true if ss < nsf || sf > nss
        details = "#{s.ssd}.#{s.ssm}-#{s.sfd}.#{s.sfm}, sub test 2"
      elsif nss > nsf
        have_error = true if ss < nsf || sf > nss
        details = "#{s.ssd}.#{s.ssm}-#{s.sfd}.#{s.sfm}, sub test 3"
      else
        errors.add(:base, "Unknown error in season overlaping validation")
        break
      end
      if have_error
        errors.add(:base, "Season overlapped with #{details}")
        break
      end
    end
  end

  def not_end_of_february
    if ((ssd == 28 || ssd == 29) && ssm == 2) ||
       ((sfd == 28 || sfd == 29) && sfm == 2)
      errors.add(:base, "28.02 or 29.02 can not be selected as season enge since Leap year complicate the search")
    end
  end

  def not_less_then_days
    nss = (ssm.to_i + (ssd.to_f / 30)).round(2)
    nsf = (sfm.to_i + (sfd.to_f / 30)).round(2)
    year = Date.current.year
    year_plus = 0
    year_plus += 1 if nss > nsf
    ss = Time.zone.parse("#{ssd}.#{ssm}.#{year}").to_date
    sf = Time.zone.parse("#{sfd}.#{sfm}.#{year + year_plus}").to_date
    Date.current.year
    # byebug
    errors.add(:base, "Season duration can not be less then 15 days") if (sf - ss).to_i < 14
  end
end
