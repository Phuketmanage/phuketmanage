class Admin::BookingPolicy < ApplicationPolicy
  def ical?
    true
  end

  def show?
    allow! if user&.role? %w[Accounting Manager]
  end

  def update?
    allow! if user&.role? %w[Manager]
  end

  def index_front?
    allow! if user&.role? %w[Owner Manager]
  end

  def timeline?
    allow! if user&.role? %w[Accounting Guest\ relation Manager]
  end

  def timeline_data?
    allow! if user&.role? %w[Accounting Guest\ relation Manager]
  end

  def destroy?
  end

  def edit?
    allow! if user&.role? %w[Manager]
  end

  def canceled?
    allow! if user&.role? %w[Accounting Manager]
  end

  def check_in_out?
    allow! if user&.role? %w[Guest\ relation Manager]
  end

  def new?
    allow! if user&.role? %w[Manager]
  end

  def index?
    allow! if user&.role? %w[Accounting Manager]
  end

  def create?
    allow! if user&.role? %w[Manager]
  end

  def create_front?
    true
  end

  def sync?
    allow! if user&.role? %w[Manager]
  end

  def update_comment_gr?
    allow! if user&.role? %w[Guest\ relation Manager]
  end

  def get_price?
    allow! if user&.role? %w[Manager]
  end
end
