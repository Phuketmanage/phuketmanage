class Admin::ReportsController < Admin::AdminController

  # @route GET /reports (reports)
  def index
    authorize! with: Admin::ReportPolicy
  end

  # @route GET /report/balance (report_balance)
  def balance
    authorize! with: Admin::ReportPolicy
    # @totals = get_owners_totals
    @users = User.joins(:roles, {transactions: :balance_outs})
                  .where('roles.name':'Owner', 'users.balance_closed': false)
                  .where('transactions.for_acc': false)
                  .group(:id)
                  .select('users.name, users.surname, users.code', '(sum(balance_outs.debit) - sum(balance_outs.credit)) as balance')
  end

  # @route GET /report/bookings (report_bookings)
  def bookings
    authorize! with: Admin::ReportPolicy
    @from, @to, @error = set_period(params)
    @house_id = params[:house_id].present? ? params[:house_id] : nil
    @houses = House.active
    if !@error
      @sources = Source.all.pluck(:id, :name).to_h

      bookings = Booking.where(start: ..@to.to_date, finish: @from.to_date..)
                        #.where.not(status:["block"])
      if @house_id.present?
        bookings = bookings.where(house_id: @house_id).all
      else
        bookings = bookings.all
      end
      # @totals = bookings.select("COUNT(id) as qty", "SUM(sale) as sale_sum", "SUM(agent) AS agent_sum", "SUM(comm) AS comm_sum", "SUM(nett) AS nett_sum")[0]
      @totals = bookings.select("COUNT(id) as qty",
                                "COUNT(id) FILTER (WHERE status = 4) as qty_cancel",
                                "COUNT(id) FILTER (WHERE status = 6) as qty_block",
                                "SUM(sale) FILTER (WHERE status != 4) as sale_sum",
                                "SUM(agent) FILTER (WHERE status != 4) AS agent_sum",
                                "SUM(comm) FILTER (WHERE status != 4) AS comm_sum",
                                "SUM(nett) FILTER (WHERE status != 4) AS nett_sum")[0]
      @details = bookings .group(:source_id)
                          .order(count: :desc)
                          .select(:source_id, "COUNT(*) AS qty",
                                              "COUNT(id) FILTER (WHERE status = 4) as qty_cancel",
                                              "COUNT(id) FILTER (WHERE status = 6) as qty_block",
                                              "SUM(sale) FILTER (WHERE status != 4) AS sale_sum",
                                              "SUM(agent) FILTER (WHERE status != 4) AS agent_sum",
                                              "SUM(comm) FILTER (WHERE status != 4) AS comm_sum",
                                              "SUM(nett) FILTER (WHERE status != 4) AS nett_sum")
    else
      flash[:alert] = @error
    end
  end

  # @route GET /report/salary (report_salary)
  def salary
    authorize! with: Admin::ReportPolicy
    @from, @to, @error = set_period(params)
    if !@error
      type_id = TransactionType.find_by(name_en: 'Rental').id
      @ts = Transaction.for_salary(type_id, @from, @to)
    else
      flash[:alert] = @error
    end
  end

  # @route GET /report/income (report_income)
  def income
    authorize! with: Admin::ReportPolicy
    @groups = HouseGroup.all
    @results = []
    @results_with_out_groups = []
    @results_with_out_houses = []
    @results_with_out_houses_or_owners = []
    if params[:groups].present?
      @from, @to, @error = set_period(params)
      if !@error.present?
        @selected_groups = params[:groups].reject(&:empty?).map(&:to_i)
        @selected_group_name = HouseGroup.where(id: @selected_groups).pluck(:id, :name).to_h
        # Transactions with houses in groups
        @selected_groups.each do |house_group|
          @values_by_type = Transaction .joins(:house, :balances)
                                        .where('transactions.date': @from..@to)
                                        .where('houses.house_group_id': house_group)
                                        .group('transactions.type_id')
                                        .pluck('transactions.type_id','SUM(debit)', 'SUM(credit)')
          @totals = Transaction .joins(:house, :balances)
                                .where('transactions.date': @from..@to)
                                .where('houses.house_group_id': house_group)
                                .group('houses.house_group_id')
                                .pluck('SUM(debit)', 'SUM(credit)')
          if @totals.any?
            total_debit = @totals[0][0] || 0
            total_credit = @totals[0][1] || 0
          end

          @results << {group_name: @selected_group_name[house_group], values_by_type: @values_by_type, total_debit: total_debit, total_credit: total_credit }
        end

        # Transactions with houses with out groups
        @values_by_type = Transaction .joins(:house, :balances)
                                      .where('transactions.date': @from..@to)
                                      .where('houses.house_group_id': nil)
                                      .group('transactions.type_id')
                                      .pluck('transactions.type_id','SUM(debit)', 'SUM(credit)')
        @totals = Transaction .joins(:house, :balances)
                              .where('transactions.date': @from..@to)
                              .where('houses.house_group_id': nil)
                              .group('houses.house_group_id')
                              .pluck('SUM(debit)', 'SUM(credit)')
        if @totals.any?
          total_debit = @totals[0][0] || 0
          total_credit = @totals[0][1] || 0
        end
        if @values_by_type.any?
          @results_with_out_groups << {group_name: nil, values_by_type: @values_by_type, total_debit: total_debit, total_credit: total_credit }
        end

        # Transactions related to owner but not related to house
        @values_by_type = Transaction .joins(:balances)
                                      .where('transactions.date': @from..@to)
                                      .where('house_id': nil)
                                      .where.not('user_id': nil)
                                      .group('transactions.type_id')
                                      .pluck('transactions.type_id','SUM(debit)', 'SUM(credit)')
        @totals = Transaction .joins(:balances)
                              .where('transactions.date': @from..@to)
                              .where('house_id': nil)
                              .where.not('user_id': nil)
                              .pluck('SUM(debit)', 'SUM(credit)')
        if @totals.any?
          total_debit = @totals[0][0] || 0
          total_credit = @totals[0][1] || 0
        end
        if @values_by_type.any?
          @results_with_out_houses << {group_name: nil, values_by_type: @values_by_type, total_debit: total_debit, total_credit: total_credit }
        end

        # Transactions with out houses or houses owners
        @values_by_type = Transaction .joins(:balances)
                                      .where('transactions.date': @from..@to)
                                      .where(house_id: nil)
                                      .where(user_id: nil)
                                      .group('transactions.type_id')
                                      .pluck('transactions.type_id','SUM(debit)', 'SUM(credit)')
        @totals = Transaction .joins(:balances)
                              .where('transactions.date': @from..@to)
                              .where('house_id': nil)
                              .where(user_id: nil)
                              .pluck('SUM(debit)', 'SUM(credit)')
        if @totals.any?
          total_debit = @totals[0][0] || 0
          total_credit = @totals[0][1] || 0
        end
        if @values_by_type.any?
          @results_with_out_houses_or_owners << {group_name: nil, values_by_type: @values_by_type, total_debit: total_debit, total_credit: total_credit }
        end

        @transaction_type_names = TransactionType.pluck(:id, :name_en).to_h

      end

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
