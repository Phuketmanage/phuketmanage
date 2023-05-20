module ControllerMacros
  def login_admin
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:admin]
      sign_in FactoryBot.create(:admin)
    end
  end

  def login_manager
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:manager]
      sign_in FactoryBot.create(:manager)
    end
  end

  def login_accounting
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:accounting]
      sign_in FactoryBot.create(:accounting)
    end
  end

  def login_owner
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:owner]
      sign_in FactoryBot.create(:owner)
    end
  end
end