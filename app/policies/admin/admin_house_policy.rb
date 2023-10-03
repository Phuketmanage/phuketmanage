class Admin::AdminHousePolicy < ApplicationPolicy
  def index?
    allow! if user&.role? %w[Manager]
  end

  def export?
    allow! if user&.role? %w[Manager]
  end

  def inactive?
  end

  def test_upload?
  end

  def show?
    allow! if user&.role? %w[Manager]
  end

  def create?
    allow! if user&.role? %w[Manager]
  end

  def update?
    allow! if user&.role? %w[Manager]
  end

  def destroy?
  end
end
