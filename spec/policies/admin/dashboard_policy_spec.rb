# spec/policies/admin/admin_house_policy_spec.rb
require 'rails_helper'

RSpec.describe Admin::DashboardPolicy, type: :policy do
  let(:user) { create(:user) }
  let(:policy) { described_class.new(user:) }

  describe "#index?" do
    subject { policy.apply(:index?) }

    context "when the user is not authorized" do
      let(:user) { nil }

      it { is_expected.to be_falsey }
    end

    context "when the user is authorized but has no roles" do
      it { is_expected.to be_falsey }
    end

    context "when the user role is an admin" do
      let(:user) { create(:user, :admin) }

      it { is_expected.to be_truthy }
    end

    context "when the user role is an owner" do
      let(:user) { create(:user, :owner) }

      it { is_expected.to be_truthy }
    end

    context "when the user role is a transfer" do
      let(:user) { create(:user, :transfer) }

      it { is_expected.to be_truthy }
    end

    context "when the user role is a maid" do
      let(:user) { create(:user, :maid) }

      it { is_expected.to be_truthy }
    end

    context "when the user role is a gardener" do
      let(:user) { create(:user, :gardener) }

      it { is_expected.to be_truthy }
    end

    context "when the user role is an accounting" do
      let(:user) { create(:user, :accounting) }

      it { is_expected.to be_truthy }
    end

    context "when the user role is a guest relation" do
      let(:user) { create(:user, :guest_relation) }

      it { is_expected.to be_truthy }
    end

    context "when the user role is a manager" do
      let(:user) { create(:user, :manager) }

      it { is_expected.to be_truthy }
    end
  end
end
