class Admin::JobMessagePolicy < ApplicationPolicy
  def create?
    allow! if user&.role? ['Maid', 'Gardener', 'Accounting', 'Guest relation', 'Manager']
  end

  def destroy?
    allow! if user&.role? ['Maid', 'Gardener', 'Accounting', 'Guest relation', 'Manager'] and @record.sender_id == user.id
  end
end
