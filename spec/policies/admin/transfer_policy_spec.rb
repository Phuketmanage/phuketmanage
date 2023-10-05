# spec/policies/admin/admin_house_policy_spec.rb
require 'rails_helper'

RSpec.describe Admin::TransferPolicy, type: :policy do
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

    context "when the user role is a transfer" do
      let(:user) { create(:user, :transfer) }

      it { is_expected.to be_truthy }
    end

    context "when the user role is a manager" do
      let(:user) { create(:user, :manager) }

      it { is_expected.to be_truthy }
    end
  end

  describe "#index_supplier?" do
    subject { policy.apply(:index_supplier?) }

    context "when the user role is an admin" do
      let(:user) { create(:user, :admin) }

      it { is_expected.to be_truthy }
    end

    context "when the user is not authorized" do
      let(:user) { nil }

      it { is_expected.to be_truthy }
    end
  end

  describe "#show?" do
    subject { policy.apply(:show?) }

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

    context "when the user role is a transfer" do
      let(:user) { create(:user, :transfer) }

      it { is_expected.to be_truthy }
    end

    context "when the user role is a manager" do
      let(:user) { create(:user, :manager) }

      it { is_expected.to be_truthy }
    end
  end

  describe "#create?" do
    subject { policy.apply(:create?) }

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

    context "when the user role is a manager" do
      let(:user) { create(:user, :manager) }

      it { is_expected.to be_truthy }
    end
  end

  describe "#confirmed?" do
    subject { policy.apply(:confirmed?) }

    context "when the user is not authorized" do
      let(:user) { nil }

      it { is_expected.to be_truthy }
    end

    context "when the user role is an admin" do
      let(:user) { create(:user, :admin) }

      it { is_expected.to be_truthy }
    end
  end

  describe "#update?" do
    subject { policy.apply(:update?) }

    context "when the user is not authorized" do
      let(:user) { nil }

      it { is_expected.to be_falsey }
    end

    context "when the user is authorized but has no roles" do
      it { is_expected.to be_falsey }
    end

    context "when the user role is a manager" do
      let(:user) { create(:user, :manager) }

      it { is_expected.to be_truthy }
    end

    context "when the user role is an admin" do
      let(:user) { create(:user, :admin) }

      it { is_expected.to be_truthy }
    end
  end

  describe "#cancel?" do
    subject { policy.apply(:cancel?) }

    context "when the user is not authorized" do
      let(:user) { nil }

      it { is_expected.to be_falsey }
    end

    context "when the user is authorized but has no roles" do
      it { is_expected.to be_falsey }
    end

    context "when the user role is a manager" do
      let(:user) { create(:user, :manager) }

      it { is_expected.to be_truthy }
    end

    context "when the user role is an admin" do
      let(:user) { create(:user, :admin) }

      it { is_expected.to be_truthy }
    end
  end

  describe "#canceled?" do
    subject { policy.apply(:canceled?) }

    context "when the user is not authorized" do
      let(:user) { nil }

      it { is_expected.to be_truthy }
    end

    context "when the user role is an admin" do
      let(:user) { create(:user, :admin) }

      it { is_expected.to be_truthy }
    end
  end

  describe "#destroy?" do
    subject { policy.apply(:destroy?) }

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
  end
end