require 'rails_helper'

RSpec.describe Booking do
  describe "Scopes" do
    describe "#active" do
      before do
        create(:booking, :paid)
        create(:booking, :confirmed)
        create(:booking, :canceled)
      end

      it "returns records that are not canceled" do
        expect(described_class.active.count).to eq(2)
        expect(described_class.active.pluck(:status)).not_to include('canceled')
      end
    end

    describe "#for_owner" do
      before do
        create(:booking, :paid, start: 2.days.from_now)
        create(:booking, :confirmed, start: 1.day.from_now)
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
        create(:booking, :paid)
        create(:booking, :confirmed)
        create(:booking, :canceled)
        create(:booking, :block)
      end

      it "returns records not canceled or block" do
        expect(described_class.real.count).to eq(2)
        expect(described_class.real.pluck(:status)).not_to include('canceled', 'block')
      end
    end

    describe "#unpaid" do
      let!(:confirmed_booking) { create(:booking, :confirmed, start: 2.days.from_now) }
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
