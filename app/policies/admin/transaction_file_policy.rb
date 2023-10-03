class Admin::TransactionFilePolicy < ApplicationPolicy
  def index?
    allow! if user&.role? %w[Owner Manager Accounting]
  end

  def download?
    allow! if user&.role? %w[Manager Accounting]
  end

  def toggle_show?
    allow! if user&.role? %w[Manager Accounting]
  end

  def destroy?
    allow! if user&.role? %w[Manager Accounting]
  end

  def destroy_tmp?
    allow! if user&.role? %w[Manager Accounting]
  end
end
