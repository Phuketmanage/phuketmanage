# frozen_string_literal: true

# == Schema Information
#
# Table name: bookings
#
#  id              :bigint           not null, primary key
#  agent           :integer
#  allotment       :boolean          default(FALSE)
#  check_in        :date
#  check_out       :date
#  client_details  :string
#  comm            :integer
#  comment         :text
#  comment_gr      :text
#  comment_owner   :string
#  finish          :date
#  ical_UID        :string
#  ignore_warnings :boolean          default(FALSE)
#  nett            :integer
#  no_check_in     :boolean          default(FALSE)
#  no_check_out    :boolean          default(FALSE)
#  number          :string
#  sale            :integer
#  start           :date
#  status          :integer
#  synced          :boolean          default(FALSE)
#  transfer_in     :boolean          default(FALSE)
#  transfer_out    :boolean          default(FALSE)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  house_id        :bigint           not null
#  source_id       :integer
#  tenant_id       :bigint
#
# Indexes
#
#  index_bookings_on_house_id   (house_id)
#  index_bookings_on_number     (number) UNIQUE
#  index_bookings_on_source_id  (source_id)
#  index_bookings_on_status     (status)
#  index_bookings_on_synced     (synced)
#  index_bookings_on_tenant_id  (tenant_id)
#
# Foreign Keys
#
#  bookings_source_id_fk  (source_id => sources.id)
#  fk_rails_...           (house_id => houses.id)
#  fk_rails_...           (tenant_id => users.id)
#
FactoryBot.define do
  factory :booking do
    client_details { Faker::Name.last_name }
    sale { Random.rand(10..90) * 1000 }
    agent { (sale * [0, 0.1].sample).to_i }
    comm { (sale * 0.02).to_i - agent }
    nett { sale - agent - comm }
    house
    start { Date.current }
    finish { start + 14.days }
    allotment { false }
    status { "confirmed" }
    trait :pending do
      status { "pending" }
    end
    trait :canceled do
      status { "canceled" }
    end
  end
end
