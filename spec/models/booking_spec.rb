require 'rails_helper'

RSpec.describe Booking do
  describe "Scopes" do
    describe "#active" do
      subject { described_class.active }

      let!(:booking_active1) { create(:booking) }
      let!(:booking_active2) { create(:booking, :paid) }
      let!(:booking_canceled) { create(:booking, :canceled) }

      it { is_expected.to include(booking_active1, booking_active2) }
      it { is_expected.not_to include(booking_canceled) }
    end

    describe "#for_owner" do
      subject { described_class.for_owner }

      let!(:booking_owner1) { create(:booking, start: 1.day.from_now) }
      let!(:booking_owner2) { create(:booking, :paid, start: 2.days.from_now) }
      let!(:booking_temporary) { create(:booking, :temporary, start: Date.current) }
      let!(:booking_canceled_owner) { create(:booking, :canceled, start: Date.current) }

      it { is_expected.to include(booking_owner1, booking_owner2) }
      it { is_expected.not_to include(booking_temporary, booking_canceled_owner) }

      it 'orders by start' do
        expect(subject.pluck(:start)).to eq(subject.pluck(:start).sort)
      end
    end

    describe "#real" do
      subject { described_class.real }

      let!(:booking_real1) { create(:booking) }
      let!(:booking_real2) { create(:booking, :paid) }
      let!(:booking_block) { create(:booking, :block) }
      let!(:booking_canceled) { create(:booking, :canceled) }

      it { is_expected.to include(booking_real1, booking_real2) }
      it { is_expected.not_to include(booking_canceled, booking_block) }
    end

    describe "#unpaid" do
      subject { described_class.unpaid }

      let!(:confirmed_booking) { create(:booking, start: 2.days.from_now) }
      let!(:pending_booking) { create(:booking, :pending, start: 1.day.from_now) }
      let!(:paid_booking) { create(:booking, :paid) }
      let!(:block_booking) { create(:booking, :block) }
      let!(:canceled_booking) { create(:booking, :canceled) }

      it { is_expected.to include(confirmed_booking, pending_booking) }
      it { is_expected.not_to include(paid_booking, block_booking, canceled_booking) }

      it 'orders by start' do
        expect(subject.pluck(:start)).to eq(subject.pluck(:start).sort)
      end
    end
  end

  describe 'Instance Methods' do
    let(:booking) { create(:booking, status: :pending, nett: 1000, sale: 1000, comm: 0, agent: 0) }
    let!(:transaction) { create(:transaction, booking:) }

    describe '#toggle_status' do
      subject { booking.toggle_status }

      context 'when partially paid' do
        let!(:balance_out) { create(:balance_out, trsc: transaction, debit: 100) }

        it 'changes status to confirmed' do
          expect { subject }.to change { booking.reload.status }.from('pending').to('confirmed')
        end
      end

      context 'when fully paid' do
        let!(:balance_out) { create(:balance_out, trsc: transaction, debit: booking.nett) }

        before { booking.update(status: :confirmed) }

        it 'changes status to paid if fully paid' do
          allow(booking).to receive(:fully_paid?).and_return(true)
          expect { subject }.to change { booking.reload.status }.from('confirmed').to('paid')
        end
      end
    end

    describe '#fully_paid?' do
      subject { booking.fully_paid? }

      context 'when booking is fully paid' do
        let!(:balance_out) { create(:balance_out, trsc: transaction, debit: booking.nett) }

        it { is_expected.to be true }
      end

      context 'when booking is not fully paid' do
        let!(:balance_out) { create(:balance_out, trsc: transaction, debit: 0) }

        it { is_expected.to be false }
      end
    end
  end

  describe 'Class Methods' do
    describe '.check_in_out' do
      subject { described_class.check_in_out(from, to, type) }

      let(:from) { nil }
      let(:to) { nil }
      let(:type) { nil }

      let!(:booking_in) { create(:booking, start: Date.current, check_in: nil) }
      let!(:booking_out) { create(:booking, finish: Date.current, check_out: nil) }
      let!(:booking_block) { create(:booking, :block) }

      context 'when no from and to dates are provided' do
        it 'returns bookings within the default date range' do
          expect(subject.pluck(:booking_id)).to include(booking_in.id, booking_out.id)
        end
      end

      context 'when type is Block' do
        let(:type) { 'Block' }

        it 'returns only block bookings' do
          expect(subject.pluck(:booking_id)).to include(booking_block.id)
          expect(subject.pluck(:booking_id)).not_to include(booking_in.id, booking_out.id)
        end
      end
    end

    describe '.timeline_data' do
      subject { described_class.timeline_data(from, to, period, house_number) }

      let(:from) { nil }
      let(:to) { nil }
      let(:period) { nil }
      let(:house_number) { nil }

      let!(:job_type) { create(:job_type, name: 'For management') }
      let!(:house) { create(:house) }
      let!(:booking_timeline) { create(:booking, house:, start: Date.current, finish: Date.current + 2.days) }

      it 'returns timeline data within the default date range' do
        expect(subject[:houses].first[:bookings].pluck(:id)).to include(booking_timeline.id)
      end

      context 'when house number is provided' do
        let(:house_number) { house.number }

        it 'returns bookings for the specified house' do
          expect(subject[:houses].first[:hid]).to eq(house_number)
        end
      end
    end
  end

  describe 'Callbacks' do
    describe 'before_validation :set_dates' do
      let(:booking) { build(:booking, period: '2024-06-01 - 2024-06-10') }

      it 'sets the start and finish dates from the period' do
        booking.valid?
        expect(booking.start).to eq(Date.parse('2024-06-01'))
        expect(booking.finish).to eq(Date.parse('2024-06-10'))
      end
    end
  end
end
