require 'rails_helper'

RSpec.describe Admin::BookingFilesController do
  login_admin

  describe 'POST /bookings/:id/booking_files' do
    let(:booking) { create(:booking, :pending) }
    let(:data) { fixture_file_upload('spec/support/files/document.jpeg', 'image/jpeg') }
    let(:valid_params) { { name: "Test file name", comment: "Test file description", data: } }

    context 'with valid params' do
      it 'creates a new booking file' do
        expect do
          post booking_files_path(booking), params: { booking_file: valid_params }
        end.to change(BookingFile, :count).by(1)

        expect(response).to redirect_to(bookings_path(booking))
      end
    end

    context 'with invalid params' do
      let(:invalid_params) { { booking_file: { name: '', comment: '' } } }

      it 'does not create a new booking file' do
        expect do
          post booking_files_path(booking), params: { booking_file: invalid_params }
        end.not_to change(BookingFile, :count)

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE /booking_files/:id' do
    let!(:booking_file) { create(:booking_file) }

    it 'deletes the booking file' do
      expect do
        delete booking_file_path(booking_file)
      end.to change(BookingFile, :count).by(-1)

      expect(response).to redirect_to(bookings_path(booking_file.booking))
    end
  end
end
