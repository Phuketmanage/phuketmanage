class Admin::WaterUsagePolicy < ApplicationPolicy
  def show?
    allow! if user&.role? %w[Gardener Manager]
  end

  def update?
    allow! if user&.role? %w[Gardener Manager]
  end

  def index?
    allow! if user&.role? %w[Gardener Manager]
  end

  def create?
    allow! if user&.role? %w[Gardener Manager]
  end

  def destroy?
  end
end
