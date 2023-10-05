# spec/policies/admin/admin_house_policy_spec.rb
require 'rails_helper'

RSpec.describe Admin::DocumentsPolicy, type: :policy do
  let(:user) { create(:user) }
  let(:policy) { described_class.new(user:) }

  describe "#reimbersment?" do
    subject { policy.apply(:reimbersment?) }

    context "when the user is not authorized" do
      let(:user) { nil }

      it { is_expected.to be_falsey }
    end

    context "when the user is authorized but has no roles" do
      it { is_expected.to be_falsey }
    end

    context "when the user role is an accounting" do
      let(:user) { create(:user, :accounting) }

      it { is_expected.to be_truthy }
    end

    context "when the user role is an admin" do
      let(:user) { create(:user, :admin) }

      it { is_expected.to be_truthy }
    end
  end

  describe "#receipt?" do
    subject { policy.apply(:receipt?) }

    context "when the user is not authorized" do
      let(:user) { nil }

      it { is_expected.to be_falsey }
    end

    context "when the user is authorized but has no roles" do
      it { is_expected.to be_falsey }
    end

    context "when the user role is an accounting" do
      let(:user) { create(:user, :accounting) }

      it { is_expected.to be_truthy }
    end

    context "when the user role is an admin" do
      let(:user) { create(:user, :admin) }

      it { is_expected.to be_truthy }
    end
  end

  describe "#statement?" do
    subject { policy.apply(:statement?) }

    context "when the user is not authorized" do
      let(:user) { nil }

      it { is_expected.to be_falsey }
    end

    context "when the user is authorized but has no roles" do
      it { is_expected.to be_falsey }
    end

    context "when the user role is an accounting" do
      let(:user) { create(:user, :accounting) }

      it { is_expected.to be_truthy }
    end

    context "when the user role is an admin" do
      let(:user) { create(:user, :admin) }

      it { is_expected.to be_truthy }
    end
  end

  describe "#invoice?" do
    subject { policy.apply(:invoice?) }

    context "when the user is not authorized" do
      let(:user) { nil }

      it { is_expected.to be_falsey }
    end

    context "when the user is authorized but has no roles" do
      it { is_expected.to be_falsey }
    end

    context "when the user role is an accounting" do
      let(:user) { create(:user, :accounting) }

      it { is_expected.to be_truthy }
    end

    context "when the user role is an admin" do
      let(:user) { create(:user, :admin) }

      it { is_expected.to be_truthy }
    end
  end
end
