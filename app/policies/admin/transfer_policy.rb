class Admin::TransferPolicy < ApplicationPolicy
  def index?
    allow! if user&.role? %w[Transfer Manager]
  end

  def index_supplier?
    true
  end

  def show?
    allow! if user&.role? %w[Transfer Manager]
  end

  def new?
    allow! if user&.role? %w[Manager]
  end

  def edit?
    allow! if user&.role? %w[Manager]
  end

  def create?
    allow! if user&.role? %w[Manager]
  end

  def confirmed?
    true
  end

  def update?
    allow! if user&.role? %w[Manager]
  end

  def cancel?
    allow! if user&.role? %w[Manager]
  end

  def canceled?
    true
  end

  def destroy?
    # allow! if user&.role? %w[Manager]
  end
end
