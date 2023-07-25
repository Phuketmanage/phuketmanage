# frozen_string_literal: true

require 'rails_helper'

describe 'Log' do
  let(:owner) { create(:user, :owner) }

  it 'is not valid' do
    expect do
      create(:log)
    end.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'is valid' do
    expect do
      create(:log, who: owner, where: "random controller", what: "example controller name", with: "example subject",
                   before: "example state before action", after: "example state after action")
    end.to change(Log, :count).by(1)
  end
end
