require 'rails_helper'

describe 'House' do
  let(:admin) { create(:user, :admin) }
  let(:manager) { create(:user, :manager) }
  let(:balance_closed) { false }
  let(:unavailable) { false }
  let!(:house) { create :house, unavailable: unavailable, balance_closed: balance_closed }
  subject { page }

  describe "Access" do

    context "when manager" do
      before { sign_in manager }

      context "when visiting houses" do
        before { visit houses_path }
        it { is_expected.to_not have_link 'Destroy' }
        it { is_expected.to_not have_link 'Inactive Houses' }
      end

      context "when visiting inactive houses" do
        before { visit houses_inactive_path }
        it { is_expected.to have_content 'You are not authorized to access this page.' }
      end
    end

    context "when admin" do
      before { sign_in admin }

      context "when visiting houses" do
        before { visit houses_path }
        it { is_expected.to have_link 'Destroy' }
        it { is_expected.to have_link 'Inactive Houses' }
      end

      context "when visiting inactive houses" do
        before { visit houses_inactive_path }
        it { is_expected.to have_content 'Inactive Houses' }
      end
    end

    describe "listing" do
      before { sign_in admin }

      describe '#unavailable' do
        before { visit houses_path}

        context 'when house is for rent' do
          let(:unavailable) { false }
          it { is_expected.to have_selector('.for_rent .house', text: house.title_en) }
        end

        context 'when house is not for rent' do
          let(:unavailable) { true }
          it { is_expected.to have_selector('.for_rent .house', text: house.title_en) }
        end
      end

      describe '#balance_closed' do
        before { visit houses_inactive_path }
        context 'when house is inactive' do
          let(:balance_closed) { true }
          it { is_expected.to have_selector('.inactive_houses .house', text: house.title_en) }
        end
      end
    end
  end
end
