require 'rails_helper'

RSpec.describe Loggable, type: :controller do
  let(:user_model) { create(:user, :client) }
  let(:update_attributes) { { id: user_model.id, name: 'newname' } }
  let(:last_log) { Log.last }
  let(:enable_logging) { Setting.create(var: "user_activity_logging_enabled") }
  let(:admin) { create(:user, :admin) }

  # Creates anonymous controller and includes Loggable concern
  controller(ApplicationController) do
    include Loggable

    def test_loggable_concern
      user = User.find(params[:id])
      if user.update(name: params[:name])
        log_event(user)
        head :ok
      else
        head :internal_server_error
      end
    end
  end

  # Drawes route for anonymous controller
  before do
    routes.draw do
      post 'test_loggable_concern' => 'anonymous#test_loggable_concern'
    end
  end

  describe 'when logging option' do
    context 'disabled' do
      it 'doesnt affect main transaction' do
        post :test_loggable_concern, params: update_attributes
        expect(response).to have_http_status(:success)
      end
      it "doesnt create log" do
        expect do
          post :test_loggable_concern, params: update_attributes
        end.not_to change(Log, :count)
      end
    end
    context 'enabled' do
      before do
        enable_logging
      end
      it 'doesnt affect main transaction' do
        post :test_loggable_concern, params: update_attributes
        expect(response).to have_http_status(:success)
      end
      it "creates log" do
        expect do
          post :test_loggable_concern, params: update_attributes
        end.to change(Log, :count).by(1)
      end
    end
  end

  describe 'Unauthorized user' do
    before do
      enable_logging
      post :test_loggable_concern, params: update_attributes
    end
    it 'saves user_email as unauthorized' do
      expect(last_log.user_email).to eq("Unauthorized")
    end
    it 'saves user_roles as unauthorized' do
      expect(last_log.user_roles).to eq(["Unauthorized"])
    end
    it 'saves location' do
      expect(last_log.location).to eq("anonymous#test_loggable_concern")
    end
    it 'saves model_gid' do
      expect(last_log.model_gid).to eq(user_model.to_global_id.to_s)
    end
    it 'saves before_values' do
      expect(last_log.before_values.count).to eq(20)
    end
    it 'saves applied_changes' do
      expect(last_log.applied_changes.count).to eq(2)
      expect(last_log.applied_changes["name"]).to eq(update_attributes[:name])
      expect(last_log.applied_changes.key?("updated_at")).to be_truthy
    end
  end
  describe 'Authorized user' do
    before do
      sign_in admin
      enable_logging
      post :test_loggable_concern, params: update_attributes
    end
    it 'saves admin user_email' do
      expect(last_log.user_email).to eq(admin.email)
    end
    it 'saves admin user_roles' do
      expect(last_log.user_roles).to eq(admin.roles.pluck(:name).join(', '))
    end
    it 'saves location' do
      expect(last_log.location).to eq("anonymous#test_loggable_concern")
    end
    it 'saves model_gid' do
      expect(last_log.model_gid).to eq(user_model.to_global_id.to_s)
    end
    it 'saves before_values' do
      expect(last_log.before_values.count).to eq(20)
    end
    it 'saves applied_changes' do
      expect(last_log.applied_changes.count).to eq(2)
      expect(last_log.applied_changes["name"]).to eq(update_attributes[:name])
      expect(last_log.applied_changes.key?("updated_at")).to be_truthy
    end
  end

  describe 'Errors' do
    before do
      # Monkey patching the Log model to make it invalid
      class Log
        validate :custom_validation
        def custom_validation
          errors.add(:base, "Custom validation error")
        end
      end

      enable_logging
    end
    it 'doesnt affect main transaction' do
      post :test_loggable_concern, params: update_attributes
      expect(response).to have_http_status(:success)
    end
    it "doesnt create log" do
      expect do
        post :test_loggable_concern, params: update_attributes
      end.not_to change(Log, :count)
    end
    it "sends error message to Rails error log" do
      allow(Rails.logger).to receive(:error)
      post :test_loggable_concern, params: update_attributes
      expect(Rails.logger).to have_received(:error).with("Error logging action at anonymous#test_loggable_concern. Reasons: Custom validation error")
    end
  end
end
