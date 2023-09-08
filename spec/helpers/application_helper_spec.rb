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
        allow(I18n).to receive(:locale).and_return(:ru)
      end

      it 'returns the current locale' do
        expect(helper.root_locale).to eq(:ru)
      end
    end
  end

  describe '#active_link' do
    context 'when the link path matches the current page' do
      it 'returns the string "active"' do
        allow(helper).to receive(:current_page?).with('/your_link_path').and_return(true)

        result = helper.active_link('/your_link_path')

        expect(result).to eq('active')
      end
    end

    context 'when the link path does not match the current page' do
      it 'does not return the string "active"' do
        allow(helper).to receive(:current_page?).with('/your_link_path').and_return(false)

        result = helper.active_link('/your_link_path')

        expect(result).to be_nil
      end
    end
  end
end
