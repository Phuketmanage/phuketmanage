# spec/policies/admin/admin_house_policy_spec.rb
require 'rails_helper'

RSpec.describe Admin::JobMessagePolicy, type: :policy do
  let(:user) { create(:user) }
  let(:job_massage) { create(:job_message) }
  let(:policy) { described_class.new(job_massage, user:) }

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

    context "when the user role is a maid and is sender of message" do
      let(:user) { create(:user, :maid) }
      let(:job_massage) { create(:job_message, sender: user) }

      it { is_expected.to be_truthy }
    end

    context "when the user role is a maid and is not sender of message" do
      let(:user) { create(:user, :maid) }
      let(:job_massage) { create(:job_message, sender: create(:user, :maid)) }

      it { is_expected.to be_falsey }
    end

    context "when the user role is a gardener and is sender of message" do
      let(:user) { create(:user, :gardener) }
      let(:job_massage) { create(:job_message, sender: user) }

      it { is_expected.to be_truthy }
    end

    context "when the user role is a gardener and is not sender of message" do
      let(:user) { create(:user, :gardener) }
      let(:job_massage) { create(:job_message, sender: create(:user, :gardener)) }

      it { is_expected.to be_falsey }
    end

    context "when the user role is a accounting and is sender of message" do
      let(:user) { create(:user, :accounting) }
      let(:job_massage) { create(:job_message, sender: user) }

      it { is_expected.to be_truthy }
    end

    context "when the user role is a accounting and is not sender of message" do
      let(:user) { create(:user, :accounting) }
      let(:job_massage) { create(:job_message, sender: create(:user, :accounting)) }

      it { is_expected.to be_falsey }
    end

    context "when the user role is a guest relation and is sender of message" do
      let(:user) { create(:user, :guest_relation) }
      let(:job_massage) { create(:job_message, sender: user) }

      it { is_expected.to be_truthy }
    end

    context "when the user role is a guest relation and is not sender of message" do
      let(:user) { create(:user, :guest_relation) }
      let(:job_massage) { create(:job_message, sender: create(:user, :guest_relation)) }

      it { is_expected.to be_falsey }
    end

    context "when the user role is a manager and is sender of message" do
      let(:user) { create(:user, :manager) }
      let(:job_massage) { create(:job_message, sender: user) }

      it { is_expected.to be_truthy }
    end

    context "when the user role is a manager and is not sender of message" do
      let(:user) { create(:user, :manager) }
      let(:job_massage) { create(:job_message, sender: create(:user, :manager)) }

      it { is_expected.to be_falsey }
    end
  end
end
