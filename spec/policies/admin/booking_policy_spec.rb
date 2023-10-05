# spec/policies/admin/admin_house_policy_spec.rb
require 'rails_helper'

RSpec.describe Admin::BookingPolicy, type: :policy do
  let(:user) { create(:user) }
  let(:policy) { described_class.new(user:) }

  describe "#ical?" do
    subject { policy.apply(:ical?) }

    context "when the user is not authorized" do
      let(:user) { nil }

      it { is_expected.to be_truthy }
    end

    context "when the user role is an admin" do
      let(:user) { create(:user, :admin) }

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

    context "when the user role is an accounting" do
      let(:user) { create(:user, :accounting) }

      it { is_expected.to be_truthy }
    end

    context "when the user role is a manager" do
      let(:user) { create(:user, :manager) }

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

  describe "#index_front?" do
    subject { policy.apply(:index_front?) }

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

    context "when the user role is an admin" do
      let(:user) { create(:user, :admin) }

      it { is_expected.to be_truthy }
    end
  end

  describe "#timeline?" do
    subject { policy.apply(:timeline?) }

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

  describe "#timeline_data?" do
    subject { policy.apply(:timeline_data?) }

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
  end

  describe "#canceled?" do
    subject { policy.apply(:canceled?) }

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

    context "when the user role is an accounting" do
      let(:user) { create(:user, :accounting) }

      it { is_expected.to be_truthy }
    end

    context "when the user role is a manager" do
      let(:user) { create(:user, :manager) }

      it { is_expected.to be_truthy }
    end
  end

  describe "#check_in_out?" do
    subject { policy.apply(:check_in_out?) }

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

    context "when the user role is a guest relation" do
      let(:user) { create(:user, :guest_relation) }

      it { is_expected.to be_truthy }
    end

    context "when the user role is a manager" do
      let(:user) { create(:user, :manager) }

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

    context "when the user role is an accounting" do
      let(:user) { create(:user, :accounting) }

      it { is_expected.to be_truthy }
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

  describe "#create?" do
    subject { policy.apply(:create?) }

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

  describe "#create_front?" do
    subject { policy.apply(:create_front?) }

    context "when the user is not authorized" do
      let(:user) { nil }

      it { is_expected.to be_truthy }
    end

    context "when the user role is an admin" do
      let(:user) { create(:user, :admin) }

      it { is_expected.to be_truthy }
    end
  end

  describe "#sync?" do
    subject { policy.apply(:sync?) }

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

  describe "#update_comment_gr?" do
    subject { policy.apply(:update_comment_gr?) }

    context "when the user is not authorized" do
      let(:user) { nil }

      it { is_expected.to be_falsey }
    end

    context "when the user is authorized but has no roles" do
      it { is_expected.to be_falsey }
    end

    context "when the user role is a guest relation" do
      let(:user) { create(:user, :guest_relation) }

      it { is_expected.to be_truthy }
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

  describe "#get_price?" do
    subject { policy.apply(:get_price?) }

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
end
