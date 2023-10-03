class Admin::JobPolicy < ApplicationPolicy
  def show?
    allow! if user&.role? %w[Accounting Guest\ relation Manager]
  end

  def laundry?
    allow! if user&.role? %w[Maid Accounting Guest\ relation Manager]
  end

  def update?
    allow! if user&.role? %w[Accounting Guest\ relation Manager]
  end

  def index?
    allow! if user&.role? %w[Accounting Guest\ relation Manager]
  end

  def update_laundry?
    allow! if user&.role? %w[Maid Accounting Guest\ relation Manager]
  end

  def new?
    allow! if user&.role? %w[Accounting Guest\ relation Manager]
  end

  def create?
    allow! if user&.role? %w[Accounting Guest\ relation Manager]
  end

  def index_new?
    allow! if user&.role? %w[Accounting Guest\ relation Manager]
  end

  def job_order?
    allow! if user&.role? %w[Accounting Guest\ relation Manager]
  end

  def edit?
    allow! if user&.role? %w[Accounting Guest\ relation Manager]
  end

  def destroy?
    allow! if user&.role? %w[Manager] or (user&.role? %w[Accounting Guest\ relation] and @record.creator_id == user.id)
  end
end
