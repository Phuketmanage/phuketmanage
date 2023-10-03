class Admin::EmployeePolicy < ApplicationPolicy
  def show?
  end

  def update?
    allow! if user&.role? %w[Manager]
  end

  def index?
    allow! if user&.role? %w[Manager]
  end

  def list_for_job?
    allow! if user&.role? %w[Manager]
  end

  def create?
    allow! if user&.role? %w[Manager]
  end

  def destroy?
    allow! if user&.role? %w[Manager]
  end
end
