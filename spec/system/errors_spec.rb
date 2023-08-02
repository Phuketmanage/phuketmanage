# frozen_string_literal: true

require 'rails_helper'

describe 'Errors', type: %i[controller system] do
  subject { page }

  describe 'when visiting wrong route' do
    before do
      visit :test_routing_error
    end

    it { is_expected.to have_content "404" }
  end

  describe 'when visiting missing resouce' do
    before do
      visit '/houses/wrong_id'
    end

    it { is_expected.to have_content "404" }
  end
end
