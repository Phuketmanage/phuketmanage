require 'rails_helper'

RSpec.describe Transaction do
  let(:type) { create(:transaction_type) }
  let(:other_type) { create(:transaction_type) }

  describe '.full' do
    let!(:jan_for_acc) { create(:transaction, date: '2023-01-01', for_acc: true) }
    let!(:jan_no_acc) { create(:transaction, date: '2023-01-15', for_acc: false) }
    let!(:feb_for_acc) { create(:transaction, date: '2023-02-01', for_acc: true) }
    let!(:feb_no_acc) { create(:transaction, date: '2023-02-15', for_acc: false) }

    describe 'returns transactions between given dates and for_acc is false' do
      subject { described_class.full('2023-01-01', '2023-01-31') }

      it { is_expected.to eq [jan_no_acc] }
    end
  end

  describe '.before' do
    let!(:jan_for_acc) { create(:transaction, date: '2023-01-01', for_acc: true) }
    let!(:jan_no_acc) { create(:transaction, date: '2023-01-15', for_acc: false) }
    let!(:feb_for_acc) { create(:transaction, date: '2023-02-01', for_acc: true) }
    let!(:feb_no_acc) { create(:transaction, date: '2023-02-15', for_acc: false) }

    describe 'returns transactions before a given date with for_acc = false' do
      subject { described_class.before('2023-01-31') }

      it { is_expected.to eq [jan_no_acc] }
    end
  end

  describe '.by_cat' do
    let!(:jan01) { create(:transaction, type:, date: '2023-01-01', for_acc: false) }
    let!(:balance_jan01) { create(:balance, trsc: jan01, debit: 100, credit: 0) }
    let!(:jan15) { create(:transaction, type:, date: '2023-01-15', for_acc: false) }
    let!(:balance_jan15) { create(:balance, trsc: jan15, debit: 0, credit: 50) }
    let!(:feb01) { create(:transaction, type: other_type, date: '2023-02-01', for_acc: false) }
    let!(:balance_feb01) { create(:balance, trsc: feb01, debit: 80, credit: 0) }
    let!(:feb15) { create(:transaction, type: other_type, date: '2023-02-15', for_acc: false) }
    let!(:balance_feb15) { create(:balance, trsc: feb15, debit: 0, credit: 40) }

    describe 'returns sum of debit and credit by category within a date range' do
      subject { described_class.by_cat('2023-01-01', '2023-01-31') }

      its(:as_json) do
        is_expected.to eq [{ "credit_sum" => "50.0", "debit_sum" => "100.0", "id" => nil, "type_id" => type.id }]
      end
    end

    describe 'returns sum of debit and credit by category within a date range' do
      subject { described_class.by_cat('2023-01-01', '2023-02-28') }

      its(:as_json) do
        is_expected.to eq [{ "credit_sum" => "50.0", "debit_sum" => "100.0", "id" => nil, "type_id" => type.id },
                           { "credit_sum" => "40.0", "debit_sum" => "80.0", "id" => nil, "type_id" => other_type.id }]
      end
    end
  end

  describe '.acc', freeze: '2023-02-01' do
    let!(:jan01) { create(:transaction, date: '2023-01-01', type:, hidden: false) }
    let!(:balance_jan01) { create(:balance, trsc: jan01, debit: 100, credit: 0) }
    let!(:jan10) { create(:transaction, date: '2023-01-10', type:, hidden: false) }
    let!(:jan15) { create(:transaction, date: '2023-01-15', type:, hidden: true) }
    let!(:balance_jan15) { create(:balance, trsc: jan15, debit: 0, credit: 50) }

    describe 'returns transactions with positive with debit or credit and hidden = false' do
      subject { described_class.acc('2023-01-01', '2023-01-31') }

      it do
        expect(subject).to eq [jan01]
      end
    end
  end

  describe '.acc_before' do
    let!(:jan01) { create(:transaction, date: '2023-01-01', type:, hidden: false) }
    let!(:jan15) { create(:transaction, date: '2023-01-15', type:, hidden: true) }

    describe 'returns transactions before a given date with hidden = false' do
      subject { described_class.acc_before('2023-02-01') }

      it { is_expected.to eq [jan01] }
    end
  end

  describe '.filtered' do
    let!(:jan01) { create(:transaction, date: '2023-01-01', type:) }
    let!(:jan15) { create(:transaction, date: '2023-01-15', type: other_type) }

    describe 'excludes transactions with specific type_ids' do
      subject { described_class.filtered([other_type.id]) }

      it { is_expected.to eq [jan01] }
    end
  end

  describe '.unlinked' do
    let!(:with_house) { create(:transaction, house: create(:house)) }
    let!(:no_house) { create(:transaction, house: nil) }

    describe 'returns transactions where house_id is nil' do
      subject { described_class.unlinked }

      it { is_expected.to eq [no_house] }
    end
  end

  describe '.for_house' do
    let!(:house) { create(:house) }
    let!(:with_house) { create(:transaction, house:) }
    let!(:no_house) { create(:transaction) }

    describe 'returns transactions for a specific house_id' do
      subject { described_class.for_house(house.id) }

      it { is_expected.to eq [with_house] }
    end
  end

  describe '.by_cat_for_owner' do
    let!(:jan01) { create(:transaction, date: '2023-01-01', type:, for_acc: false) }
    let!(:balance_jan01_1) { create(:balance_out, trsc: jan01, debit: 100, credit: 0) }
    let!(:balance_jan01_2) { create(:balance_out, trsc: jan01, debit: 0, credit: 33) }
    let!(:jan15) { create(:transaction, date: '2023-01-15', type:, for_acc: true) }
    let!(:balance_jan15) { create(:balance_out, trsc: jan15, debit: 0, credit: 50) }

    describe 'returns sum of debit and credit by category for owners (for_acc: false) within a date range' do
      subject { described_class.by_cat_for_owner('2023-01-01', '2023-01-31') }

      its(:as_json) do
        is_expected.to eq [{ "credit_sum" => "33.0", "debit_sum" => "100.0", "id" => nil, "type_id" => type.id }]
      end
    end
  end

  describe '.full_acc_for_owner' do
    let(:owner) { create(:user) }
    let!(:owner_shown) { create(:transaction, date: '2023-01-01', type:, user: owner, hidden: false) }
    let!(:owner_hidden) { create(:transaction, date: '2023-01-5', type:, user: owner, hidden: true) }
    let!(:other) { create(:transaction, date: '2023-01-15', type:, for_acc: true) }

    describe 'returns transactions for a specific owner within a date range' do
      subject { described_class.full_acc_for_owner('2023-01-01', '2023-01-31', owner.id) }

      it { is_expected.to eq [owner_shown] }
    end
  end

  describe '.before_acc_for_owner' do
    let(:owner) { create(:user) }
    let!(:owner_shown) { create(:transaction, date: '2023-01-01', type:, user: owner, hidden: false) }
    let!(:owner_hidden) { create(:transaction, date: '2023-01-5', type:, user: owner, hidden: true) }
    let!(:other) { create(:transaction, date: '2023-01-15', type:, for_acc: true) }

    describe 'returns transactions for a specific owner before a given date' do
      subject { described_class.before_acc_for_owner('2023-02-01', owner.id) }

      it { is_expected.to eq [owner_shown] }
    end
  end

  describe '.for_salary' do
    let(:type) { create(:transaction_type) }
    let(:house) { create(:house, code: 'H123') }
    let(:booking_within_range) { create(:booking, start: '2023-01-10', finish: '2023-01-20', house:) }
    let(:booking_outside_range) { create(:booking, start: '2023-02-01', finish: '2023-02-10', house:) }

    let!(:transaction_within_range) { create(:transaction, type:, date: '2023-01-15', booking: booking_within_range) }
    let!(:balance_within_range) { create(:balance, trsc: transaction_within_range, debit: 200) }

    let!(:transaction_before_range) { create(:transaction, type:, date: '2023-01-05', booking: booking_within_range) }
    let!(:balance_before_range) { create(:balance, trsc: transaction_before_range, debit: 150) }

    let!(:transaction_outside_range) { create(:transaction, type:, date: '2023-02-05', booking: booking_outside_range) }
    let!(:balance_outside_range) { create(:balance, trsc: transaction_outside_range, debit: 100) }

    describe 'returns salary transactions within a given range and associated with bookings and houses' do
      subject { described_class.for_salary(type.id, '2023-01-01', '2023-01-31') }

      its(:as_json) do
        is_expected.to contain_exactly({
                                         "id" => transaction_within_range.id,
                                         "date" => "2023-01-15",
                                         "booking_id" => booking_within_range.id,
                                         "house_code" => "H123",
                                         "booking_start" => "2023-01-10",
                                         "booking_finish" => "2023-01-20",
                                         "income" => "200.0"
                                       }, {
                                         "id" => transaction_before_range.id,
                                         "date" => "2023-01-05",
                                         "booking_id" => booking_within_range.id,
                                         "house_code" => "H123",
                                         "booking_start" => "2023-01-10",
                                         "booking_finish" => "2023-01-20",
                                         "income" => "150.0"
                                       })
      end
    end
  end

  describe '#write_to_balance' do
    subject do
      double( # rubocop:disable RSpec/VerifiedDoubles
        balances: transaction.balances.as_json.map { _1.slice("credit", "debit") },
        balance_outs: transaction.balance_outs.as_json.map { _1.slice("credit", "debit") },
        errors: transaction.errors.as_json
      )
    end

    let(:transaction) { create(:transaction, house_id: house&.id, user_id: user&.id) }
    let(:house) { create(:house) }
    let(:user) { create(:user) }

    let(:params) do
      {
        type:,
        deposit_owner: 100,
        credit_owner: 0,
        deposit_company: 50,
        credit_company: 0
      }
    end
    let(:type) { "Rental" }

    before do
      transaction.write_to_balance(params[:type], params[:deposit_owner], params[:credit_owner],
                                   params[:deposit_company], params[:credit_company])
    end

    context 'when type is type1: Rental' do
      let(:params) do
        {
          type: "Rental",
          deposit_owner: 100,
          credit_owner: 0,
          deposit_company: 50,
          credit_company: 0
        }
      end

      its(:balances) do
        is_expected.to eq [
          { "credit" => "0.0", "debit" => "50.0" }
        ]
      end

      its(:balance_outs) do
        is_expected.to eq [
          { "credit" => "0.0", "debit" => "100.0" },
          { "credit" => "50.0", "debit" => "0.0" }
        ]
      end

      context 'when house_id is missing' do
        let(:house) { nil }

        its(:errors) { is_expected.to eq(base: ['Need to select owner or house']) }
      end

      context 'when user_id is missing' do
        let(:user) { nil }

        its(:errors) { is_expected.to eq(base: ['Need to select owner or house']) }
      end
    end

    context 'when type is type2: Maintenance' do
      context 'when deposit_company is greater than zero' do
        let(:params) do
          {
            type: 'Maintenance',
            deposit_owner: 100,
            credit_owner: 0,
            deposit_company: 50,
            credit_company: 0
          }
        end

        its(:balances) do
          is_expected.to eq [
            { "credit" => nil, "debit" => "50.0" }
          ]
        end

        its(:balance_outs) do
          is_expected.to eq [
            { "credit" => "50.0", "debit" => "0.0" }
          ]
        end
      end

      context 'when deposit_company is zero and credit_owner is greater than zero' do
        let(:params) do
          {
            type: 'Maintenance',
            deposit_owner: 100,
            credit_owner: 50,
            deposit_company: 0,
            credit_company: 0
          }
        end

        its(:balances) { is_expected.to eq [] }

        its(:balance_outs) do
          is_expected.to eq [
            { "credit" => "50.0", "debit" => "0.0" }
          ]
        end
      end

      context 'with blank payments' do
        let(:params) { { type: 'Maintenance' } }

        its(:errors) { is_expected.to eq(base: ['"Pay to outside" and "Pay to Phaethon" can not be blank both']) }
      end

      context 'when house_id is missing' do
        let(:house) { nil }

        its(:errors) { is_expected.to eq(base: ['Need to select owner or house']) }
      end

      context 'when house AND user are missing' do
        let(:house) { nil }
        let(:user) { nil }

        its(:errors) { is_expected.to eq(base: ['Need to select owner or house']) }
      end

      context 'when user_id is missing' do
        let(:user) { nil }

        its(:errors) { is_expected.to eq(base: ['Need to select owner or house']) }
      end
    end

    context 'when type is type3: Top up, From guests' do
      let(:params) do
        {
          type: 'Top up',
          deposit_owner: 100,
          credit_owner: 0,
          deposit_company: 0, # irrelevant for type3
          credit_company: 0
        }
      end

      its(:balance_outs) do
        is_expected.to eq [
          { "credit" => "0.0", "debit" => "100.0" }
        ]
      end

      context 'when house_id and user_id are missing' do
        let(:house) { nil }
        let(:user) { nil }

        its(:errors) { is_expected.to eq(base: ['Need to select owner or house']) }
      end

      context 'when deposit_owner is zero' do
        let(:params) do
          super().merge(deposit_owner: 0)
        end

        its(:errors) { is_expected.to eq(base: ['Amount can not be blank']) }
      end
    end

    context 'when type is type4: Repair, Purchases, Consumables, Improvements' do
      let(:params) do
        {
          type: 'Repair',
          deposit_owner: 0,
          credit_owner: 100,
          deposit_company: 50,
          credit_company: 25
        }
      end

      its(:balance_outs) do
        is_expected.to eq [
          { "credit" => "100.0", "debit" => "0.0" },
          { "credit" => "75.0", "debit" => "0.0" } # cr_co + de_co
        ]
      end

      its(:balances) do
        is_expected.to eq [
          { "credit" => "0.0", "debit" => "75.0" }, # cr_co + de_co
          { "credit" => "25.0", "debit" => "0.0" } # cr_co
        ]
      end

      context 'when user_id is missing' do
        let(:user) { nil }

        its(:errors) { is_expected.to eq(base: ['Need to select owner']) }
      end

      context 'when all amounts are zero' do
        let(:params) do
          super().merge(deposit_owner: 0, credit_owner: 0, deposit_company: 0, credit_company: 0)
        end

        its(:errors) { is_expected.to eq(base: ['Amount can not be blank']) }
      end
    end

    context 'when type is type5: Utilities, Yearly contracts, Insurance, To owner, Common area, Transfer' do
      let(:params) do
        {
          type: 'Utilities',
          deposit_owner: 0, # irrelevant for type5
          credit_owner: 100,
          deposit_company: 0, # irrelevant for type5
          credit_company: 0 #  irrelevant for type5
        }
      end

      its(:balance_outs) do
        is_expected.to eq [
          { "credit" => "100.0", "debit" => "0.0" }
        ]
      end

      context 'when both house_id and user_id are missing' do
        let(:house) { nil }
        let(:user) { nil }

        its(:errors) { is_expected.to eq(base: ['Need to select owner or house']) }
      end

      context 'when credit_owner is zero' do
        let(:params) do
          super().merge(credit_owner: 0)
        end

        its(:errors) { is_expected.to eq(base: ['Amount can not be blank']) }
      end
    end

    context 'when type is type6: Salary, Gasoline, Office, Suppliers, Eqp & Cons, Taxes & Accounting, etc.' do
      let(:params) do
        {
          type: 'Salary',
          deposit_owner: 0, # irrelevant for type6
          credit_owner: 0, # irrelevant for type6
          deposit_company: 0, #  irrelevant for type6
          credit_company: 100
        }
      end

      its(:balances) do
        is_expected.to eq [
          { "credit" => "100.0", "debit" => "0.0" }
        ]
      end

      context 'when credit_company is zero' do
        let(:params) do
          super().merge(credit_company: 0)
        end

        its(:errors) { is_expected.to eq(base: ['Amount can not be blank']) }
      end
    end

    context 'when type is type7: Other' do
      let(:params) do
        {
          type: 'Other',
          deposit_owner: 50,
          credit_owner: 100,
          deposit_company: 75,
          credit_company: 25
        }
      end

      its(:balance_outs) do
        is_expected.to eq [
          { "credit" => "0.0", "debit" => "50.0" },
          { "credit" => "100.0", "debit" => "0.0" }
        ]
      end

      its(:balances) do
        is_expected.to eq [
          { "credit" => "0.0", "debit" => "75.0" },
          { "credit" => "25.0", "debit" => "0.0" }
        ]
      end

      context 'when only deposit_owner is greater than zero' do
        let(:params) do
          super().merge(deposit_owner: 50, credit_owner: 0, deposit_company: 0, credit_company: 0)
        end

        its(:balances) { is_expected.to eq [] }
        its(:balance_outs) { is_expected.to eq [{ "credit" => "0.0", "debit" => "50.0" }] }
      end

      context 'when only credit_owner is greater than zero' do
        let(:params) do
          super().merge(deposit_owner: 0, credit_owner: 100, deposit_company: 0, credit_company: 0)
        end

        its(:balances) { is_expected.to eq [] }
        its(:balance_outs) { is_expected.to eq [{ "credit" => "100.0", "debit" => "0.0" }] }
      end

      context 'when only deposit_company is greater than zero' do
        let(:params) do
          super().merge(deposit_owner: 0, credit_owner: 0, deposit_company: 75, credit_company: 0)
        end

        its(:balances) { is_expected.to eq [{ "credit" => "0.0", "debit" => "75.0" }] }
        its(:balance_outs) { is_expected.to eq [] }
      end

      context 'when only credit_company is greater than zero' do
        let(:params) do
          super().merge(deposit_owner: 0, credit_owner: 0, deposit_company: 0, credit_company: 25)
        end

        its(:balances) { is_expected.to eq [{ "credit" => "25.0", "debit" => "0.0" }] }
        its(:balance_outs) { is_expected.to eq [] }
      end

      context 'when all amounts are zero' do
        let(:params) do
          super().merge(deposit_owner: 0, credit_owner: 0, deposit_company: 0, credit_company: 0)
        end

        its(:errors) { is_expected.to eq(base: ['Amount can not be blank']) }
      end

      context 'when both house_id and user_id are missing' do
        let(:house) { nil }
        let(:user) { nil }

        its(:errors) { is_expected.to eq(base: ['Need to select owner or house']) }
      end
    end

    context 'when type is unknown' do
      let(:type) { 'Unknown type' }

      its(:errors) { is_expected.to eq(base: ['Transaction type is not programmed yet']) }
    end
  end

  describe '#set_owner_and_house' do
    subject(:transaction) { create(:transaction, user: nil, booking: nil, house: nil) }

    let(:owner) { create(:user, :owner) }
    let(:house) { create(:house, owner:) }
    let(:booking) { create(:booking, house:) }
    let(:user) { create(:user) }

    context 'when user_id is nil and house_id is present' do
      before do
        transaction.user_id = nil
        transaction.house_id = house.id
        transaction.set_owner_and_house
      end

      its(:user_id) { is_expected.to eq owner.id }
    end

    context 'when house_id is nil and booking_id is present' do
      before do
        transaction.house_id = nil
        transaction.booking_id = booking.id
        transaction.set_owner_and_house
      end

      its(:house_id) { is_expected.to eq(house.id) }
      its(:user_id) { is_expected.to eq(owner.id) }
    end

    context 'when both user_id and house_id are nil and booking_id is present' do
      let(:user_without_house) { create(:user) }

      before do
        booking.house.owner = user_without_house
        transaction.user_id = nil
        transaction.house_id = nil
        transaction.booking_id = booking.id
        transaction.set_owner_and_house
      end

      its(:house_id) { is_expected.to eq(house.id) }
      its(:user_id) { is_expected.to eq(owner.id) }
    end

    context 'when user_id, house_id, and booking_id are all nil' do
      before { transaction.set_owner_and_house }

      its(:house_id) { is_expected.to be_nil }
      its(:user_id) { is_expected.to be_nil }
    end
  end
end
