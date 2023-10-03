class Admin::TransactionPolicy < ApplicationPolicy
  def show?
  end

  def new?
    allow! if user&.role? %w[Manager Accounting]
  end

  def update?
    allow! if user&.role? %w[Manager Accounting] and check_edit_or_update(@record)
  end

  def docs?
    allow! if user&.role? %w[Manager Accounting]
  end

  def index?
    allow! if user&.role? %w[Owner Manager Accounting]
  end

  def create?
    allow! if user&.role? %w[Manager Accounting]
  end

  def warnings?
  end

  def update_invoice_ref?
    allow! if user&.role? %w[Manager Accounting]
  end

  def edit?
    allow! if user&.role? %w[Manager Accounting] and check_edit_or_update(@record)
  end

  def destroy?
    allow! if user&.role? %w[Manager Accounting] and check_destroy(@record)
  end

  def raw_for_acc?
    allow! if user&.role? %w[Admin]
  end

  private

  def check_edit_or_update(transaction)
    transaction.date >= (Date.current - 30.days).beginning_of_month
  end

  def check_destroy(transaction)
    transaction.date > Date.current - 1.day
  end
end
