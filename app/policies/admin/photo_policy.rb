class Admin::PhotoPolicy < ApplicationPolicy
  def update?
    allow! if user&.role? %w[Manager]
  end

  def index?
    allow! if user&.role? %w[Manager]
  end

  def delete_all?
    allow! if user&.role? %w[Manager]
  end

  def sort?
    allow! if user&.role? %w[Manager]
  end

  def destroy?
    allow! if user&.role? %w[Manager]
  end
end
