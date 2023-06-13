class ReportsController < ApplicationController
  load_and_authorize_resource :class => false
  layout 'admin'

  def index
    # @totals = get_owners_totals
    @users = User.joins(:roles, {transactions: :balance_outs})
                  .where('roles.name':'Owner', 'users.balance_closed': false)
                  .where('transactions.for_acc': false)
                  .group(:id)
                  .select('users.name', '(sum(balance_outs.debit) - sum(balance_outs.credit)) as balance')
  end

private
  # def get_owners_totals

  # end

end
