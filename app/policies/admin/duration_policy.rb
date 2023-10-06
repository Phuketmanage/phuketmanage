class Admin::DurationPolicy < ApplicationPolicy
  def show?
    allow! if user&.role? %w[Manager]
  end

  def update?
    allow! if user&.role? %w[Manager]
  end

  def index?
    allow! if user&.role? %w[Manager]
  end

  def create?
    allow! if user&.role? %w[Manager]
  end

  def destroy?
    allow! if user&.role? %w[Manager]
  end
end
