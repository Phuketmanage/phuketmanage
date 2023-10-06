# spec/policies/admin/admin_house_policy_spec.rb
require 'rails_helper'

RSpec.describe Admin::TransactionPolicy, type: :policy do
  let(:user) { create(:user) }
  let(:transaction) { create(:transaction) }
  let(:policy) { described_class.new(transaction, user:) }

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

    context "when the user role is an admin" do
      let(:user) { create(:user, :admin) }

      it { is_expected.to be_truthy }
    end

    context "when the user role is a manager and transaction date 60 days earlier" do
      let(:user) { create(:user, :manager) }
      let(:transaction) { create(:transaction, date: (Date.current - 60.days)) }

      it { is_expected.to be_falsey }
    end

    context "when the user role is a manager and transaction date is today" do
      let(:user) { create(:user, :manager) }
      let(:transaction) { create(:transaction, date: Date.current) }

      it { is_expected.to be_truthy }
    end

    context "when the user role is an accounting and transaction date 60 days earlier" do
      let(:user) { create(:user, :accounting) }
      let(:transaction) { create(:transaction, date: (Date.current - 60.days)) }

      it { is_expected.to be_falsey }
    end

    context "when the user role is an accounting and transaction date is today" do
      let(:user) { create(:user, :accounting) }
      let(:transaction) { create(:transaction, date: Date.current) }

      it { is_expected.to be_truthy }
    end
  end

  describe "#docs?" do
    subject { policy.apply(:docs?) }

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

    context "when the user role is an accounting" do
      let(:user) { create(:user, :accounting) }

      it { is_expected.to be_truthy }
    end
  end

  describe "#index?" do
    subject { policy.apply(:index?) }

    context "when the user is not authorized" do
      let(:user) { nil }

      it { is_expected.to be_falsey }
    end

    context "when the user is authorized but has no roles" do
      it { is_expected.to be_falsey }
    end

    context "when the user role is an owner" do
      let(:user) { create(:user, :owner) }

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

    context "when the user role is an admin" do
      let(:user) { create(:user, :admin) }

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

    context "when the user role is an accounting" do
      let(:user) { create(:user, :accounting) }

      it { is_expected.to be_truthy }
    end
  end

  describe "#warnings?" do
    subject { policy.apply(:warnings?) }

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

  describe "#update_invoice_ref?" do
    subject { policy.apply(:update_invoice_ref?) }

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

    context "when the user role is an accounting" do
      let(:user) { create(:user, :accounting) }

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

    context "when the user role is a manager and transaction date 1 day earlier" do
      let(:user) { create(:user, :manager) }
      let(:transaction) { create(:transaction, date: (Date.current - 1.day)) }

      it { is_expected.to be_falsey }
    end

    context "when the user role is a manager and transaction date is today" do
      let(:user) { create(:user, :manager) }
      let(:transaction) { create(:transaction, date: Date.current) }

      it { is_expected.to be_truthy }
    end

    context "when the user role is an accounting and transaction date 1 day earlier" do
      let(:user) { create(:user, :accounting) }
      let(:transaction) { create(:transaction, date: (Date.current - 1.day)) }

      it { is_expected.to be_falsey }
    end

    context "when the user role is an accounting and transaction date is today" do
      let(:user) { create(:user, :accounting) }
      let(:transaction) { create(:transaction, date: Date.current) }

      it { is_expected.to be_truthy }
    end
  end

  describe "#raw_for_acc?" do
    subject { policy.apply(:raw_for_acc?) }

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
