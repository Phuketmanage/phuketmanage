class Admin::SourcePolicy < ApplicationPolicy
  def show?
    allow! if user&.role? %w[Manager]
  end

  def new?
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

  def edit?
    allow! if user&.role? %w[Manager]
  end

  def destroy?
  end
end
