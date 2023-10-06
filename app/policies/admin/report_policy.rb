class Admin::ReportPolicy < ApplicationPolicy
  def index?
    allow! if user&.role? %w[Manager]
  end

  def salary?
  end

  def bookings?
    allow! if user&.role? %w[Manager]
  end

  def balance?
  end
end
