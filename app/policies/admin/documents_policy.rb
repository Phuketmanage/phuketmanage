class Admin::DocumentsPolicy < ApplicationPolicy
  
  def design_agreement?
    allow! if user&.role? %w[Accounting]
  end
  
  def reimbersment?
    allow! if user&.role? %w[Accounting]
  end

  def receipt?
    allow! if user&.role? %w[Accounting]
  end

  def statement?
    allow! if user&.role? %w[Accounting]
  end

  def invoice?
    allow! if user&.role? %w[Accounting]
  end
end
