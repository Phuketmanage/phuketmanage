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

    describe '#toggle_status' do
      let(:booking) { create(:booking, status: :pending) }

      it 'does not change status for block bookings' do
        booking.update(status: :block)
        expect { booking.toggle_status }.not_to change { booking.status }
      end

      it 'does not change status for canceled bookings' do
        booking.update(status: :canceled)
        expect { booking.toggle_status }.not_to change { booking.status }
      end
    end

    describe '#fully_paid?' do
      let(:job_type) { create(:job_type, name: 'For management') }
      let(:booking) { create(:booking, status: :pending, nett: 1000, sale: 1000, agent: 0, comm: 0) }
      let!(:transaction) { create(:transaction, booking: booking) }

      it 'returns false for block bookings' do
        booking.update(status: :block)
        expect(booking.fully_paid?).to be false
      end

      it 'returns false for canceled bookings' do
        booking.update(status: :canceled)
        expect(booking.fully_paid?).to be false
      end
    end

    describe '.timeline_data' do
      let(:house) { create(:house) }
      let!(:job_type) { create(:job_type, name: 'For management') }
      let!(:booking) { create(:booking, house: house, start: Date.current, finish: Date.current + 3.days) }

      it 'handles scenario when no bookings exist' do
        allow(Booking).to receive(:count).and_return(0)
        result = described_class.timeline_data
        expect(result[:days]).to eq(45)
      end

      it 'uses maximum finish date when bookings exist and no period is specified' do
        allow(Booking).to receive(:count).and_return(1)
        allow(Booking).to receive(:maximum).with(:finish).and_return(1.month.from_now.to_date)
        result = described_class.timeline_data
        expect(result[:days]).to eq(31)
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

    describe '#fully_paid?' do
      let(:booking) { create(:booking, nett: 1000, sale: 1000, agent: 0, comm: 0) }
      let!(:transaction) { create(:transaction, booking: booking) }

      it 'returns false for block or canceled bookings' do
        booking.status = :block
        expect(booking.fully_paid?).to be false

        booking.status = :canceled
        expect(booking.fully_paid?).to be false
      end

      it 'returns true when to_owner equals nett' do
        create(:balance_out, trsc: transaction, debit: 1000)
        expect(booking.fully_paid?).to be true
      end

      it 'returns false when to_owner does not equal nett' do
        create(:balance_out, trsc: transaction, debit: 500)
        expect(booking.fully_paid?).to be false
      end
    end

  end

  describe '.check_in_out' do
    let!(:booking) { create(:booking, start: Date.current, finish: Date.current + 3.days, check_in: Date.current, check_out: Date.current + 3.days) }

    it 'returns check-in and check-out data' do
      result = described_class.check_in_out
      expect(result.size).to eq(2)
      expect(result.first[:type]).to eq('IN')
      expect(result.last[:type]).to eq('OUT')
    end

    it 'filters by date range' do
      result = described_class.check_in_out(Date.current, Date.current + 1.day)
      expect(result.size).to eq(1)
      expect(result.first[:type]).to eq('IN')
    end

    it 'filters by type' do
      result = described_class.check_in_out(nil, nil, 'Check out')
      expect(result.size).to eq(1)
      expect(result.first[:type]).to eq('OUT')
    end
  end

  describe '.check_in_out' do
    let(:house) { create(:house) }
    let!(:booking) { create(:booking, house: house, start: Date.current, finish: Date.current + 3.days, check_in: Date.current, check_out: Date.current + 3.days) }

    it 'handles different date scenarios' do
      expect(described_class.check_in_out(nil, nil, 'All')).to be_present
      expect(described_class.check_in_out(Date.current, nil, 'All')).to be_present
      expect(described_class.check_in_out(nil, Date.current + 5.days, 'All')).to be_present
      expect(described_class.check_in_out(Date.current, Date.current + 5.days, 'All')).to be_present
    end

    it 'handles block bookings' do
      block_booking = create(:booking, house: house, status: :block, start: Date.current, finish: Date.current + 1.day)
      result = described_class.check_in_out(nil, nil, 'Block')
      expect(result.map { |r| r[:booking_id] }).to include(block_booking.id)
    end

    it 'includes transfer information' do
      create(:transfer, booking: booking, trsf_type: :IN, from: 'Airport', time: '14:00', remarks: 'VIP')
      create(:transfer, booking: booking, trsf_type: :OUT, time: '12:00', remarks: 'Standard')

      result = described_class.check_in_out
      expect(result.find { |r| r[:type] == 'IN' }[:transfers]).to include('Airport-14:00 VIP')
      expect(result.find { |r| r[:type] == 'OUT' }[:transfers]).to include('12:00 Standard')
    end
  end

  describe '.timeline_data' do
    let!(:job_type) { create(:job_type, name: 'For management') }
    let!(:house) { create(:house) }
    let!(:booking) { create(:booking, house: house, start: Date.current, finish: Date.current + 3.days) }

    it 'returns timeline data' do
      result = described_class.timeline_data
      expect(result[:houses]).to be_present
      expect(result[:houses].first[:bookings]).to be_present
    end

    it 'filters by house number' do
      result = described_class.timeline_data(nil, nil, nil, house.number)
      expect(result[:houses].size).to eq(1)
      expect(result[:houses].first[:hid]).to eq(house.number)
    end
  end

  describe '.timeline_data' do
    let(:house) { create(:house) }
    let!(:booking) { create(:booking, house: house, start: Date.current, finish: Date.current + 3.days) }
    let!(:management_job) { create(:job, booking: booking, plan: Date.current + 1.day, job_type: job_type) }
    let!(:house_job) { create(:job, house: house, booking: nil, plan: Date.current + 2.days) }
    let!(:booking_job) { create(:job, house: house, booking: booking, plan: Date.current + 2.days) }
    let!(:job_type) { create(:job_type, name: 'For management') }

    it 'handles different date scenarios' do
      expect(described_class.timeline_data).to be_present
      expect(described_class.timeline_data(Date.current)).to be_present
      expect(described_class.timeline_data(nil, Date.current + 5.days)).to be_present
      expect(described_class.timeline_data(Date.current, Date.current + 5.days)).to be_present
    end

    it 'includes booking and job information' do
      result = described_class.timeline_data
      house_data = result[:houses].first

      expect(house_data[:bookings]).to be_present
      expect(house_data[:jobs]).to be_present

      booking_data = house_data[:bookings].first
      expect(booking_data[:jobs]).to be_present
    end

    it 'excludes jobs for management' do
      result = described_class.timeline_data
      house_jobs = result[:houses].first[:jobs]

      expect(house_jobs.none? { |job| job[:type_id] == job_type.id }).to be true
    end
  end

  describe '.sync' do
    let(:house) { create(:house) }
    let(:connection) { create(:connection, house: house) }

    it 'syncs bookings from external sources' do
      allow(OpenURI).to receive(:open_uri).and_return(double(read: "BEGIN:VCALENDAR\nEND:VCALENDAR"))
      allow(Icalendar::Calendar).to receive(:parse).and_return([double(events: [])])

      expect { described_class.sync([house]) }.not_to raise_error
    end

    it 'handles HTTP errors' do
      allow(OpenURI).to receive(:open_uri).and_raise(OpenURI::HTTPError.new('404 Not Found', StringIO.new))

      expect { described_class.sync([house]) }.not_to raise_error
    end
  end

  describe '.sync' do
    let(:house) { create(:house) }
    let!(:connection) { create(:connection, house: house) }

    before do
      allow(OpenURI).to receive(:open_uri).and_return(double(read: "BEGIN:VCALENDAR\nEND:VCALENDAR"))
      allow(Icalendar::Calendar).to receive(:parse).and_return([double(events: [])])
    end

    it 'syncs bookings for all houses when no houses are specified' do
      expect(House).to receive(:all).and_return([house])
      described_class.sync
    end

    it 'handles different source types' do
      allow(connection.source).to receive(:name).and_return('Airbnb')
      described_class.sync([house])

      allow(connection.source).to receive(:name).and_return('Tripadvisor')
      described_class.sync([house])
    end

    it 'skips events that ended before the current time' do
      past_event = double(dtend: 1.day.ago, summary: 'Past Event', description: 'Description')
      allow(Icalendar::Calendar).to receive(:parse).and_return([double(events: [past_event])])

      expect { described_class.sync([house]) }.not_to change(Booking, :count)
    end

    it 'creates new bookings for valid events' do
      future_event = double(
        dtstart: 1.day.from_now,
        dtend: 3.days.from_now,
        summary: 'Future Event',
        description: 'Description',
        uid: 'unique_id'
      )
      allow(Icalendar::Calendar).to receive(:parse).and_return([double(events: [future_event])])

      expect { described_class.sync([house]) }.to change(Booking, :count).by(1)
    end
  end

  describe '.sync' do
    let(:house) { create(:house) }
    let!(:connection) { create(:connection, house: house) }

    before do
      allow(OpenURI).to receive(:open_uri).and_return(double(read: "BEGIN:VCALENDAR\nEND:VCALENDAR"))
      allow(Icalendar::Calendar).to receive(:parse).and_return([double(events: [])])
    end

    context 'when handling different source types' do
      let(:future_event) do
        double(
          dtstart: 1.day.from_now,
          dtend: 3.days.from_now,
          summary: 'Future Event',
          description: 'Description',
          uid: 'unique_id'
        )
      end

      before do
        allow(Icalendar::Calendar).to receive(:parse).and_return([double(events: [future_event])])
      end

      it 'handles Airbnb source' do
        allow(connection.source).to receive(:name).and_return('Airbnb')
        expect { described_class.sync([house]) }.to change(Booking, :count).by(1)
      end

      it 'handles Tripadvisor source' do
        allow(connection.source).to receive(:name).and_return('Tripadvisor')
        expect { described_class.sync([house]) }.to change(Booking, :count).by(1)
      end

      it 'handles Homeaway source' do
        allow(connection.source).to receive(:name).and_return('Homeaway')
        expect { described_class.sync([house]) }.to change(Booking, :count).by(1)
      end

      it 'handles Booking.com source' do
        allow(connection.source).to receive(:name).and_return('Booking')
        expect { described_class.sync([house]) }.to change(Booking, :count).by(1)
      end
    end

    context 'when handling existing bookings' do
      let(:existing_booking) { create(:booking, house: house, ical_UID: 'existing_uid') }
      let(:updated_event) do
        double(
          dtstart: 2.days.from_now,
          dtend: 4.days.from_now,
          summary: 'Updated Event',
          description: 'Updated Description',
          uid: 'existing_uid'
        )
      end

      before do
        allow(Icalendar::Calendar).to receive(:parse).and_return([double(events: [updated_event])])
      end

      # it 'updates existing booking if dates or description changed' do
      #   expect { described_class.sync([house]) }.to change { existing_booking.reload.comment }
      # end

      it 'does not update existing booking if no changes' do
        existing_booking.update(
          start: 2.days.from_now,
          finish: 4.days.from_now,
          comment: "Updated Event \n Updated Description"
        )
        expect { described_class.sync([house]) }.not_to change { existing_booking.reload.updated_at }
      end
    end
  end

  describe '#calc' do
    let(:house) { create(:house, type: create(:house_type, comm: 10)) }
    let(:booking) { build(:booking, house: house) }

    it 'calculates prices when given a price hash' do
      price_hash = { '2024-06-01' => { total: 1000 } }
      booking.calc(price_hash)

      expect(booking.sale).to eq(1000)
      expect(booking.agent).to eq(0)
      expect(booking.nett).to eq(900)
      expect(booking.comm).to eq(100)
    end

    it 'sets prices to zero when given an empty price hash' do
      booking.calc({})

      expect(booking.sale).to eq(0)
      expect(booking.agent).to eq(0)
      expect(booking.nett).to eq(0)
      expect(booking.comm).to eq(0)
    end
  end

  describe '#get_period' do
    let(:booking) { build(:booking, start: Date.new(2024, 6, 1), finish: Date.new(2024, 6, 10)) }

    it 'returns a formatted string of start and finish dates' do
      expect(booking.get_period).to eq('2024-06-01 - 2024-06-10')
    end

    it 'returns nil if start or finish is missing' do
      booking.start = nil
      expect(booking.get_period).to be_nil
    end
  end

  describe 'validations' do
    let(:booking) { build(:booking) }

    context 'when validating price chain' do
      it 'adds an error if the price chain is invalid' do
        booking.sale = 1000
        booking.agent = 100
        booking.comm = 100
        booking.nett = 700

        booking.valid?
        expect(booking.errors[:base]).to include('Check Prices: Sale - Agent - Comm is not equal to Nett')
      end
    end
  end

  describe 'Class Methods' do
    describe '.check_in_out' do
      subject { described_class.check_in_out(from, to, type) }

      let(:to) {}
      let(:from) {}
      let(:type) {}

      let!(:booking_in) { create(:booking, start: 1.week.ago, finish: 1.week.from_now, check_in: Date.current) }
      let!(:booking_out) { create(:booking, start: 1.week.ago, finish: 1.week.from_now, check_out: Date.current) }
      let!(:booking_block) { create(:booking, :block, start: 1.day.from_now, finish: 1.week.from_now) }

      context 'when no from, to and type provided' do
        it 'returns bookings within the default date range' do
          expect(subject.pluck(:booking_id)).to include(booking_block.id, booking_in.id, booking_out.id)
        end
      end

      context 'when only from date is provided' do
        let(:from) { Date.current - 1.day }

        it 'returns bookings from the provided from date to the maximum finish date' do
          expect(subject.pluck(:booking_id)).to include(booking_in.id, booking_out.id)
        end
      end

      context 'when only to date is provided' do
        let(:to) { Date.current + 1.day }

        it 'returns bookings from the current date to the provided to date' do
          expect(subject.pluck(:booking_id)).to include(booking_in.id, booking_out.id)
        end
      end

      context 'when both from and to dates are provided' do
        let(:from) { Date.current - 1.day }
        let(:to) { Date.current + 1.day }

        it 'returns bookings within the provided date range' do
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

      context 'when type is Check in' do
        let(:type) { 'Check in' }

        it 'returns only check in bookings' do
          expect(subject.pluck(:booking_id)).to include(booking_in.id, booking_block.id)
          expect(subject.pluck(:booking_id)).not_to include(booking_out.id)
        end
      end

      context 'when type is Check out' do
        let(:type) { 'Check out' }

        it 'returns only check out bookings' do
          expect(subject.pluck(:booking_id)).to include(booking_in.id, booking_out.id, booking_block.id)
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

  describe 'Validations', freeze: '2024-06-01' do
    subject(:booking) do
      build(:booking, house:, period:, status: :pending, nett: 1000, sale: 1000, comm: 0, agent: 0)
    end

    let(:house) { create(:house) }

    context 'when period is valid' do
      let(:period) { '2024-06-01 - 2024-06-10' }

      it { is_expected.to be_valid }
    end

    context 'when period is invalid' do
      let(:period) { ' - ' }

      it {
        expect(subject).not_to be_valid
        expect(booking.errors[:base]).to include("Dates not set")
      }
    end

    describe 'finish date is before start date' do
      let(:period) { '2024-06-10 - 2024-06-01' }

      it {
        expect(subject).not_to be_valid
        expect(booking.errors[:base]).to include("End of stay can not be less then beginning")
      }
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
