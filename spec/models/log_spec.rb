# frozen_string_literal: true

require 'rails_helper'

describe Log do
  let(:log) { build(:log) }

  it "is valid with valid attributes" do
    expect(log).to be_valid
  end

  it "is not valid without a user_email" do
    log.user_email = nil
    expect(log).to be_invalid
  end

  it "is not valid without a user_roles" do
    log.user_roles = nil
    expect(log).to be_invalid
  end

  it "is not valid without a location" do
    log.location = nil
    expect(log).to be_invalid
  end

  it "is not valid without a model_gid" do
    log.model_gid = nil
    expect(log).to be_invalid
  end

  it "is not valid without a before_values" do
    log.before_values = nil
    expect(log).to be_invalid
  end

  it "is not valid without a applied_changes" do
    log.applied_changes = nil
    expect(log).to be_invalid
  end
end
