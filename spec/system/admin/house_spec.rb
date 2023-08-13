# frozen_string_literal: true

require 'rails_helper'

describe 'House' do
  subject { page }

  let(:admin) { create(:user, :admin) }
  let(:manager) { create(:user, :manager) }
  let(:balance_closed) { false }
  let(:unavailable) { false }
  let!(:house) { create(:house, unavailable:, balance_closed:) }

  describe "view" do
    context "when visiting root page in en" do
      before { visit "/" }
      it { is_expected.to have_content "Project: #{house.project}" }
    end

    context "when visiting root page in ru" do
      before { visit "/ru" }
      it { is_expected.to have_content "Проект: #{house.project}" }
    end

    context "when visiting show page in en" do
      before { visit "/houses/#{house.number}" }
      it { is_expected.to have_content "Project: #{house.project}" }
    end

    context "when visiting show page in ru" do
      before { visit "/ru/houses/#{house.number}" }
      it { is_expected.to have_content "Проект: #{house.project}" }
    end
  end

  describe "Access" do
    context "when manager" do
      before { sign_in manager }

      context "when visiting houses" do
        before { visit admin_houses_path }

        it { is_expected.not_to have_link 'Destroy' }
        it { is_expected.not_to have_link 'Inactive Houses' }
      end

      context "when visiting inactive houses" do
        before { visit inactive_admin_houses_path }

        it { is_expected.to have_content 'You are not authorized to access this page.' }
      end
    end

    context "when admin" do
      before { sign_in admin }

      context "when visiting houses" do
        before { visit admin_houses_path }

        it { is_expected.to have_link 'Destroy' }
        it { is_expected.to have_link 'Inactive Houses' }
      end

      context "when visiting inactive houses" do
        before { visit inactive_admin_houses_path }

        it { is_expected.to have_content 'Inactive Houses' }
      end
    end

    describe "listing" do
      before { sign_in admin }

      describe '#unavailable' do
        before { visit admin_houses_path }

        context 'when house is for rent' do
          let(:unavailable) { false }

          it { is_expected.to have_selector('.for_rent .house', text: house.title_en) }
        end

        context 'when house is not for rent' do
          let(:unavailable) { true }

          it { is_expected.to have_selector('.not_for_rent .house', text: house.title_en) }
        end
      end

      describe '#balance_closed' do
        before { visit inactive_admin_houses_path }

        context 'when house is inactive' do
          let(:balance_closed) { true }

          it { is_expected.to have_selector('.inactive_houses .house', text: house.title_en) }
        end
      end
    end
  end
  describe 'Export' do
    before { sign_in admin }
    it "has export button on houses index" do
      visit admin_houses_path
      expect(page).to have_link('Export list')
    end
    context 'export page' do
      before do
        visit export_admin_houses_path
      end
      it "there is export page without menu block" do
        expect(page).to have_no_selector('nav')
      end
      it "there is print button" do
        expect(page).to have_button('Print')
      end
      it "has section headers" do
        expect(page).to have_selector('h5#active_hs', text: 'Houses for rent')
        expect(page).to have_selector('h5#nactive_hs', text: 'Houses not for rent')
      end
      context 'block Houses for rent' do
        it "has table headers" do
          expect(page).to have_selector('th', text: 'House Code')
          expect(page).to have_selector('th', text: 'Project/Address')
        end
        it "has table content" do
          expect(page).to have_selector('strong', text: house.code)
          expect(page).to have_selector('span', text: "Project: #{house.project}")
          expect(page).to have_selector('span', text: "Address: #{house.address}")
        end
      end
      context 'block Houses not for rent' do
        let(:unavailable) { true }
        it "shows unavaliable houses" do
          expect(page).to have_selector('strong', text: house.code)
          expect(page).to have_selector('span', text: "Project: #{house.project}")
          expect(page).to have_selector('span', text: "Address: #{house.address}")
        end
      end
    end
  end
end
