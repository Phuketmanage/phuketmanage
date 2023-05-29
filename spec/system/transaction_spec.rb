require 'rails_helper'

describe 'Transaction' do
  let(:admin) { create(:user, :admin)}

  it "should be valid for save" do
    sign_in admin
    visit new_transaction_path
  end
end