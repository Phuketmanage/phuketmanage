require 'rails_helper'

RSpec.describe Guests::IndexHelper, type: :helper do
  describe '#redirected_locale_params' do
    let(:params) do
      ActionController::Parameters.new(period: '2022-2023',
                                       search: { period: '2022-2023', type: %w[A B],
                                                 bdr: %w[X Y], location: %w[P Q] })
    end

    before do
      allow(helper)
        .to receive(:params)
        .and_return(params)
    end

    it 'returns the params object' do
      expect(helper.redirected_locale_params).to be_a(ActionController::Parameters)
    end

    it 'returns the permitted locale params' do
      expect(helper.redirected_locale_params).to eq params.permit!
    end
  end
end
