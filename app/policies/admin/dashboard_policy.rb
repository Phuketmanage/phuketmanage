class Admin::DashboardPolicy < ApplicationPolicy
  def index?
    allow! if user&.role? ['Owner', 'Transfer', 'Maid', 'Gardener', 'Accounting', 'Guest relation', 'Manager']
  end
end
