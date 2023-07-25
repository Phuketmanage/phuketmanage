# frozen_string_literal: true

require 'rails_helper'

describe 'User' do
  it "scope should return proper records" do
    expect do
      create_list(:user, 3, :owner, balance_closed: true)
    end.to change { User.inactive_owners.count }.by(3)
    expect do
      create_list(:user, 5, :owner)
    end.to change { User.active_owners.count }.by(5)
  end
end
