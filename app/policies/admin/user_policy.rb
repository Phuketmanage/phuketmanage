class Admin::UserPolicy < ApplicationPolicy
  def new?
  end

  def inactive?
  end

  def update?
  end

  def password_reset_request?
  end

  def get_houses?
    allow! if user&.role? %w[Manager]
  end

  def index?
    allow! if user&.role? %w[Manager]
  end

  def create?
  end

  def edit?
  end

  def destroy?
  end
end
