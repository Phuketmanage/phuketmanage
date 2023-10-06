class Admin::BookingFilePolicy < ApplicationPolicy
  def update?
    allow! if user&.role? %w[Manager]
  end

  def create?
    allow! if user&.role? %w[Manager]
  end

  def destroy?
    allow! if user&.role? %w[Manager]
  end
end
