require 'rails_helper'

RSpec.describe House do
  let(:house) { create(:house) }

  describe 'occupied_days', freeze: '2023-02-01' do
    subject(:occupied_days) { house.occupied_days }

    let(:current_date) { '2023-02-01'.to_date }
    let(:bookings) do
      create(:booking, house:, start: current_date, finish: current_date + 6.days, status: "pending") # Booked from 1 Febrary 2023 to 7 Febrary 2023
      create(:booking, house:, start: current_date + 9.days, finish: current_date + 16.days, status: "pending") # Booked from 10 Febrary 2023 to 17 Febrary 2023
    end

    let(:valid_output) { [{ from: "2023-02-01", to: "2023-02-07" }, { from: "2023-02-10", to: "2023-02-17" }] }

    context 'when none days are occupied' do
      it "returns array" do
        expect(occupied_days).to be_an_instance_of(Array)
      end

      it "is empty" do
        expect(occupied_days).to be_empty
      end
    end

    context 'when there are occupied days' do
      before do
        bookings
      end

      it "returns array" do
        expect(occupied_days).to be_an_instance_of(Array)
      end

      it "has two occupied periods" do
        expect(occupied_days.count).to eq(2)
      end

      it "returns array with occupied days in hashes" do
        expect(occupied_days[0]).to be_an_instance_of(Hash)
      end

      it "properly formats periods" do
        expect(occupied_days).to eq valid_output
      end
    end

    context 'with dtnb setting' do
      subject(:occupied_days_with_dtnb) { house.occupied_days(dtnb) }

      let(:dtnb) { 1 }
      let(:valid_output) do
        [{ from: "2023-01-31", to: "2023-02-08" }, { from: "2023-02-09", to: "2023-02-18" }]
      end

      before do
        bookings
      end

      it "takes the dtnb into account" do
        expect(occupied_days_with_dtnb).to eq valid_output
      end
    end
  end
end
