# frozen_string_literal: true

require 'rails_helper'

describe 'Log', :type => :model do
  let(:owner) { create(:user, :owner)}
  it 'shouldn\'t be valid' do
    expect do
      create(:log)
    end.to raise_error(ActiveRecord::RecordInvalid)
  end
  it 'should be valid' do
    expect do
      log.save
    end.to change { Log.count }.by(1)
  end
end
