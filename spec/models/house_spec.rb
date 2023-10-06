# == Schema Information
#
# Table name: houses
#
#  id                    :bigint           not null, primary key
#  address               :string
#  balance_closed        :boolean          default(FALSE), not null
#  bathrooms             :integer
#  cancellationPolicy_en :text
#  cancellationPolicy_ru :text
#  capacity              :integer
#  code                  :string
#  communal_pool         :boolean
#  description_en        :text
#  description_ru        :text
#  details               :text
#  google_map            :string
#  hide_in_timeline      :boolean          default(FALSE), not null
#  image                 :string
#  kingBed               :integer
#  maintenance           :boolean          default(FALSE)
#  number                :string(10)
#  other_en              :text
#  other_ru              :text
#  outsource_cleaning    :boolean          default(FALSE)
#  outsource_linen       :boolean          default(FALSE)
#  parking               :boolean
#  parking_size          :integer
#  photo_link            :string
#  plot_size             :integer
#  pool                  :boolean
#  pool_size             :string
#  priceInclude_en       :text
#  priceInclude_ru       :text
#  project               :string
#  queenBed              :integer
#  rental                :boolean          default(FALSE)
#  rooms                 :integer
#  rules_en              :text
#  rules_ru              :text
#  seaview               :boolean          default(FALSE)
#  secret                :string
#  singleBed             :integer
#  size                  :integer
#  title_en              :string
#  title_ru              :string
#  unavailable           :boolean          default(FALSE)
#  water_meters          :integer          default(1)
#  water_reading         :boolean          default(FALSE)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  house_group_id        :bigint
#  owner_id              :bigint           not null
#  type_id               :bigint           not null
#
# Indexes
#
#  index_houses_on_bathrooms       (bathrooms)
#  index_houses_on_code            (code)
#  index_houses_on_communal_pool   (communal_pool)
#  index_houses_on_house_group_id  (house_group_id)
#  index_houses_on_number          (number) UNIQUE
#  index_houses_on_owner_id        (owner_id)
#  index_houses_on_parking         (parking)
#  index_houses_on_rooms           (rooms)
#  index_houses_on_type_id         (type_id)
#  index_houses_on_unavailable     (unavailable)
#
# Foreign Keys
#
#  fk_rails_...  (house_group_id => house_groups.id)
#  fk_rails_...  (owner_id => users.id)
#  fk_rails_...  (type_id => house_types.id)
#
require 'rails_helper'

RSpec.describe House do
  let(:house) { create(:house) }

  describe 'occupied_days', freeze: '2023-02-01' do
    subject(:occupied_days) { house.occupied_days }

    let(:current_date) { '2023-02-01'.to_date }
    let(:bookings) do
      create(:booking, :pending, house:, start: current_date, finish: current_date + 6.days) # Booked from 1 Febrary 2023 to 7 Febrary 2023
      create(:booking, :pending, house:, start: current_date + 9.days, finish: current_date + 16.days) # Booked from 10 Febrary 2023 to 17 Febrary 2023
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

  context 'when add new house for rental' do
    let(:house) { build(:house, rooms: 0, rental: true) }
    let(:house_rooms) { build(:house, rooms: 1, rental: true) }

    it 'with rooms' do
      expect(house_rooms).to be_valid
    end

    it 'without rooms' do
      expect(house).not_to be_valid
    end
  end

  context 'when add new house for not rental' do
    let(:house) { build(:house, rooms: 0) }

    it { expect(house).to be_valid }
  end
end
