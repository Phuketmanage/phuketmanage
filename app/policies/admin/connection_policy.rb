class Admin::ConnectionPolicy < ApplicationPolicy
  def create?
    allow! if user&.role? %w[Manager]
  end

  def destroy?
    allow! if user&.role? %w[Manager]
  end
end
