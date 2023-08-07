# frozen_string_literal: true

require 'rails_helper'

describe 'Search' do
  subject { page }

  let(:owner_one) { create(:user, :owner) }
  let(:owner_two) { create(:user, :owner) }
  let(:villa) { create(:house_type, :villa) }
  let(:location_one) { create(:location) }
  let(:location_two) { create(:location) }
  let(:townhouse) { create(:house_type, :townhouse) }
  let(:appartment) { create(:house_type, :appartment) }
  let!(:house_one) { create(:house, :with_seasons, owner: owner_one, type: villa, rooms: 3, locations: [location_one]) }
  let!(:house_two) do
    create(:house, :with_seasons, owner: owner_one, type: townhouse, rooms: 2, locations: [location_two])
  end
  let!(:house_three) do
    create(:house, :with_seasons, owner: owner_one, type: appartment, rooms: 1, locations: [location_two])
  end
  let!(:house_four) do
    create(:house, :with_seasons, owner: owner_two, type: villa, rooms: 4, locations: [location_one])
  end
  let(:booking_period_from) { 5.days.from_now.to_date.to_fs }
  let(:booking_period_to) { 14.days.from_now.to_date.to_fs }
  let(:period_from) { 10.days.from_now.to_date.to_fs }
  let(:period_to) { 20.days.from_now.to_date.to_fs }
  let!(:booking) do
    create(:booking, house: house_two, start: booking_period_from, finish: booking_period_to, status: "pending")
  end

  context 'when pass only date' do
    before do
      visit "/search?search%5Bperiod%5D=#{period_from}+to+#{period_to}&commit=Search"
    end

    it { is_expected.to have_selector('.house', count: 3) }
    it { is_expected.to have_content house_one.code.to_s }
    it { is_expected.not_to have_content house_two.code.to_s }
    it { is_expected.to have_content house_three.code.to_s }
    it { is_expected.to have_content house_four.code.to_s }
  end

  context 'when pass with type' do
    before do
      visit "/search?search%5Bperiod%5D=#{period_from}+to+#{period_to}&commit=Searchs&search%5Btype%5D%5B%5D=#{villa.id}"
    end

    it { is_expected.to have_selector('.house', count: 2) }
    it { is_expected.to have_content house_one.code.to_s }
    it { is_expected.to have_content house_four.code.to_s }
  end

  context 'when pass with location' do
    before do
      visit "/search?search%5Bperiod%5D=#{period_from}+to+#{period_to}&commit=Search&search%5Blocation%5D%5B%5D=#{location_one.id}"
    end

    it { is_expected.to have_selector('.house', count: 2) }
    it { is_expected.to have_content house_one.code.to_s }
    it { is_expected.to have_content house_four.code.to_s }
  end

  context 'when pass with type and location' do
    before do
      visit "/search?search%5Bperiod%5D=#{period_from}+to+#{period_to}&commit=Search&search%5Blocation%5D%5B%5D=#{location_one.id}&search%5Btype%5D%5B%5D=#{villa.id}"
    end

    it { is_expected.to have_selector('.house', count: 2) }
    it { is_expected.to have_content house_one.code.to_s }
    it { is_expected.to have_content house_four.code.to_s }
  end

  context 'when pass all parameters' do
    before do
      visit "/search?search%5Bperiod%5D=#{period_from}+to+#{period_to}&commit=Search&search%5Blocation%5D%5B%5D=#{location_one.id}&search%5Btype%5D%5B%5D=#{villa.id}&search%5Bbdr%5D%5B%5D=3"
    end

    it { is_expected.to have_selector('.house', count: 1) }
    it { is_expected.to have_content house_one.code.to_s }
  end
end
