class Admin::TranslationPolicy < ApplicationPolicy
  def show?
    allow! if user&.role? %w[Accounting Manager]
  end
end
