# spec/policies/admin/admin_house_policy_spec.rb
require 'rails_helper'

RSpec.describe Admin::SearchPolicy, type: :policy do
  let(:user) { create(:user) }
  let(:policy) { described_class.new(user:) }

  describe "#index?" do
    subject { policy.apply(:index?) }

    context "when the user role is an admin" do
      let(:user) { create(:user, :admin) }

      it { is_expected.to be_truthy }
    end

    context "when the user role is a manager" do
      let(:user) { create(:user, :manager) }

      it { is_expected.to be_truthy }
    end

    context "when the user role is an accounting" do
      let(:user) { create(:user, :accounting) }

      it { is_expected.to be_truthy }
    end

    context "when the user is not authorized" do
      let(:user) { nil }

      it { is_expected.to be_falsey }
    end

    context "when the user is authorized but has no roles" do
      it { is_expected.to be_falsey }
    end
  end
end
