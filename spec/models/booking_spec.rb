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
require 'rails_helper'

RSpec.describe Booking do
  describe "Scopes" do
    describe "#active" do
      before do
        create(:booking)
        create(:booking, :paid)
        create(:booking, :canceled)
      end

      it "returns records that are not canceled" do
        expect(described_class.active.count).to eq(2)
        expect(described_class.active.pluck(:status)).not_to include('canceled')
      end
    end

    describe "#for_owner" do
      before do
        create(:booking, start: 1.day.from_now)
        create(:booking, :paid, start: 2.days.from_now)
        create(:booking, :temporary, start: Date.current)
        create(:booking, :canceled, start: Date.current)
      end

      it "returns records not canceled or temporary, ordered by start" do
        expect(described_class.for_owner.count).to eq(2)
        expect(described_class.for_owner.pluck(:status)).not_to include('canceled', 'temporary')
        expect(described_class.for_owner.order(:start).pluck(:start)).to eq([1.day.from_now.to_date,
                                                                             2.days.from_now.to_date])
      end
    end

    describe "#real" do
      before do
        create(:booking)
        create(:booking, :paid)
        create(:booking, :canceled)
        create(:booking, :block)
      end

      it "returns records not canceled or block" do
        expect(described_class.real.count).to eq(2)
        expect(described_class.real.pluck(:status)).not_to include('canceled', 'block')
      end
    end

    describe "#unpaid" do
      let!(:confirmed_booking) { create(:booking, start: 2.days.from_now) }
      let!(:pending_booking) { create(:booking, :pending, start: 1.day.from_now) }

      before do
        create(:booking, :paid)
        create(:booking, :block)
        create(:booking, :canceled)
      end

      it "returns records not paid, block, or canceled, joins with house and orders by start" do
        expect(described_class.unpaid.count(:id)).to eq(2)
        expect(described_class.unpaid.pluck(:status)).not_to include('paid', 'block', 'canceled')
        expect(described_class.unpaid.first.attributes.keys).to include("id", "start", "finish", "code", "owner_id")
        expect(described_class.unpaid.order(:start).pluck(:start)).to eq([1.day.from_now.to_date, 2.days.from_now.to_date])
      end
    end
  end
end
