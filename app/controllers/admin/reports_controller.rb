class ReportsController < AdminController
  load_and_authorize_resource :class => false
  layout 'admin'

  # @route GET (/:locale)/reports {locale: nil} (reports)
  def index
  end

  # @route GET (/:locale)/report/balance {locale: nil} (report_balance)
  def balance
    # @totals = get_owners_totals
    @users = User.joins(:roles, {transactions: :balance_outs})
                  .where('roles.name':'Owner', 'users.balance_closed': false)
                  .where('transactions.for_acc': false)
                  .group(:id)
                  .select('users.name', '(sum(balance_outs.debit) - sum(balance_outs.credit)) as balance')
  end

  # @route GET (/:locale)/report/bookings {locale: nil} (report_bookings)
  def bookings
    @from, @to, @error = set_period(params)
    @house_id = params[:house_id].present? ? params[:house_id] : nil
    @houses = House.active
    if !@error
      @total = Booking.where(start: ..@to.to_date, finish: @from.to_date..).count
      if @house_id.present?
        @details = Booking.where(start: ..@to.to_date, finish: @from.to_date.., house_id: @house_id).group(:source_id).order(count: :desc).count
      else
        @details = Booking.where(start: ..@to.to_date, finish: @from.to_date..).group(:source_id).order(count: :desc).count
      end
    else
      flash[:alert] = @error
    end
  end

  # @route GET (/:locale)/report/salary {locale: nil} (report_salary)
  def salary
    @from, @to, @error = set_period(params)
    if !@error
      type_id = TransactionType.find_by(name_en: 'Rental').id
      @ts = Transaction.for_salary(type_id, @from, @to)
    else
      flash[:alert] = @error
    end
  end

private

  def set_period params
    from = params[:from]
    to = params[:to]
    error = false
    if !from.present? && !to.present?
      from = Date.current.beginning_of_month
      to = Date.current.end_of_month
    elsif !from.present? || !to.present?
      error = 'Both dates should be selected'
    end
    [from, to, error]
  end

end
