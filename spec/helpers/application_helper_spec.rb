require 'rails_helper'

RSpec.describe ApplicationHelper do
  describe '#root_locale' do
    context 'when I18n.locale is :en' do
      before do
        allow(I18n).to receive(:locale).and_return(:en)
      end

      it 'returns nil' do
        expect(helper.root_locale).to be_nil
      end
    end

    context 'when I18n.locale is not :en' do
      before do
        allow(I18n).to receive(:locale).and_return(:fr)
      end

      it 'returns the current locale' do
        expect(helper.root_locale).to eq(:fr)
      end
    end
  end
end
