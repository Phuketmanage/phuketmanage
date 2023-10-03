class Admin::SearchPolicy < ApplicationPolicy
  def index?
    allow! if user&.role? %w[Manager Accounting]
  end
end
