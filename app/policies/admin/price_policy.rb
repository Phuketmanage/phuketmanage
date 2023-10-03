class Admin::PricePolicy < ApplicationPolicy
  def show?
    allow! if user&.role? %w[Manager]
  end

  def update?
    allow! if user&.role? %w[Manager]
  end

  def create_duration?
    allow! if user&.role? %w[Manager]
  end

  def create_season?
    allow! if user&.role? %w[Manager]
  end

  def copy_table?
    allow! if user&.role? %w[Manager]
  end

  def log_event?
    allow! if user&.role? %w[Manager]
  end

  def destroy_duration?
    allow! if user&.role? %w[Manager]
  end

  def destroy_season?
    allow! if user&.role? %w[Manager]
  end

  def destroy?
    allow! if user&.role? %w[Manager]
  end

  def index?
    allow! if user&.role? %w[Manager]
  end
end
