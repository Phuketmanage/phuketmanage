# frozen_string_literal: true

require 'rails_helper'

describe 'Transaction' do
  subject { page }

  let(:admin) { create(:user, :admin) }
  let(:manager) { create(:user, :manager) }
  let!(:transaction) { create(:transaction) }

  describe 'Show' do
    context "when transactions filter" do
      let(:another_trsc) { create(:transaction) }

      before do
        visit "/transactions?from=#{1.day.ago}&to=#{1.day.from_now}&balance_of=#{transaction.user}"
      end

      it { is_expected.not_to have_content another_trsc.house.code }
      it { is_expected.to have_content transaction.house.code }
    end
  end
end
