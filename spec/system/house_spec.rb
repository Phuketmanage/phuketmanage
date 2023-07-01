require 'rails_helper'

describe 'House' do
  let(:admin) { create(:user, :admin) }
  let(:manager) { create(:user, :manager) }
  let!(:house) { create(:house) }

  context "when manager" do
    before { sign_in manager }

    it "inactive shouldn't be accesed from manager" do
      visit houses_inactive_path
      expect(page).to have_content 'You are not authorized to access this page.'
    end

    it "shouldn't have Destroy link for other roles" do
      visit houses_path
      expect(page).to have_no_link 'Destroy'
    end

    it "shouldn't have Inactive button for other roles" do
      visit houses_path
      expect(page).to have_no_link 'Inactive Houses'
    end
  end

  context "when admin" do
    before { sign_in admin }

    it "inactive should be accessed by admin" do
      visit houses_inactive_path
      expect(page).to have_content 'Inactive Houses'
    end

    it "should have Inactive button for admin" do
      visit houses_path
      expect(page).to have_link 'Inactive Houses'
    end

    it "should have Destroy link for admin" do
      sign_in admin
      visit houses_path
      expect(page).to have_link 'Destroy'
    end
  end
end
