class ReportsController < ApplicationController
  load_and_authorize_resource :class => false
  layout 'admin'

  def index
  end

  def balance
    # @totals = get_owners_totals
    @users = User.joins(:roles, {transactions: :balance_outs})
                  .where('roles.name':'Owner', 'users.balance_closed': false)
                  .where('transactions.for_acc': false)
                  .group(:id)
                  .select('users.name', '(sum(balance_outs.debit) - sum(balance_outs.credit)) as balance')
  end

  def bookings
    @from, @to, @error = set_period(params)
    if !@error
      @house_id = params[:house_id].present? ? params[:house_id] : nil
      @houses = House.active
      @total = Booking.where(start: ..@to.to_date, finish: @from.to_date..).count
      if @house_id.present?
        @details = Booking.where(start: ..@to.to_date, finish: @from.to_date.., house_id: @house_id).group(:source_id).order(count: :desc).count
      else
        @details = Booking.where(start: ..@to.to_date, finish: @from.to_date..).group(:source_id).order(count: :desc).count
      end
    end
  end

private

  def set_period params
    from = params[:from]
    to = params[:to]
    error = false
    if !from.present? && !to.present?
      from = Time.zone.now.in_time_zone('Bangkok').beginning_of_month.to_date
      to = Time.zone.now.in_time_zone('Bangkok').end_of_month.to_date
    elsif !from.present? || !to.present?
      error = 'Both dates should be selected'
    end
    [from, to, error]
  end

end
