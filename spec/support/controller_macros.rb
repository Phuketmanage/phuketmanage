module ControllerMacros
  def login_admin
    before do
      sign_in FactoryBot.create(:user, :admin)
    end
  end

  def login_manager
    before do
      sign_in FactoryBot.create(:user, :manager)
    end
  end

  def login_accounting
    before do
      sign_in FactoryBot.create(:user, :accounting)
    end
  end

  def login_owner
    before do
      sign_in FactoryBot.create(:user, :owner)
    end
  end
end
