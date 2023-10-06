class ApplicationPolicy < ActionPolicy::Base
  authorize :user, optional: true
  pre_check :allow_admins

  def index?
    false
  end

  def show?
    false
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  private

  def allow_admins
    allow! if user&.role? 'Admin'
  end
end
