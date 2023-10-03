class ApplicationPolicy < ActionPolicy::Base
  authorize :user, optional: true
  pre_check :allow_admins

  private

    def allow_admins
      allow! if user&.role? 'Admin'
    end
end
