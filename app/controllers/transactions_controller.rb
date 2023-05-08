class TransactionsController < ApplicationController
  load_and_authorize_resource

  before_action :set_transaction, only: %i[show edit update destroy]
  layout 'admin'

  # @route GET /transactions (transactions)
  # @route GET /balance (balance_front)
  def index
    @from = params[:from]
    @to = params[:to]
    session[:from] = params[:from]
    session[:to] = params[:to]
    if !@from.present? && !@to.present?
      @from = Time.zone.now.in_time_zone('Bangkok').beginning_of_month.to_date
      @to = Time.zone.now.in_time_zone('Bangkok').end_of_month.to_date
    elsif !@from.present? || !@to.present?
      @error = 'Both dates should be selected'
    end

    @owner_id = params[:owner_id].present? ? params[:owner_id].to_i : nil
    @house_id = params[:house_id].present? ? params[:house_id].to_i : nil
    @owners = set_owners
    @houses = []
    unless @error.present?
      # Balance of company
      if @owner_id.nil? &&
         current_user.role?(%w[Admin Manager Accounting])
        # Gray balance
        if params[:commit] != 'Acc'
          if current_user.role?(['Admin'])
            @transactions = Transaction.where('date >= ? AND date <= ?', @from, @to).order(:date, :created_at).all
            @transactions_before = Transaction.where('date < ?', @from).all
            @transactions_by_cat = Transaction.joins(:balances).where('date >= ? AND date <= ? AND for_acc = false', @from, @to).group(:type_id).select(
              :type_id, "sum(balances.debit) as debit_sum", "sum(balances.credit) as credit_sum"
            )
          else
            salary = TransactionType.find_by(name_en: 'Salary')
            @transactions = Transaction.where('date >= ? AND date <= ? AND type_id !=?', @from, @to, salary.id).order(
              :date, :created_at
            ).all
            @transactions_before = Transaction.where('date < ?', @from).all
            @transactions_by_cat = Transaction.joins(:balances).where('date >= ? AND date <= ? AND type_id !=? AND for_acc = false', @from, @to, salary.id).group(:type_id).select(
              :type_id, "sum(balances.debit) as debit_sum", "sum(balances.credit) as credit_sum"
            )
          end
          session.delete(:owner_id)
          @view = 'company'
          session[:commit] = params[:commit]
          session[:view] = @view
        end
      # White balance
      # Balance of selected owner
      elsif !@owner_id.nil? || current_user.role?(['Owner'])
        if current_user.role?(['Owner'])
          @owner = current_user
          @locale = @owner.locale || 'en'
        # Owner view for management
        elsif current_user.role?(%w[Admin Manager Accounting])
          session[:owner_id] = @owner_id
          session[:house_id] = @house_id
          @owner = User.find(@owner_id)
          @locale = 'en'
        end
        @houses = @owner.houses.select(:id, :code)
        session[:commit] = params[:commit]
        # Gray balance (owner can see only this)
        if params[:commit] != 'Acc'
          if @house_id.nil? # House not selected
            @transactions = @owner.transactions.where('date >= ? AND date <= ?', @from, @to).order(:date,
                                                                                                   :created_at).all
            @transactions_before = @owner.transactions.where('date < ?', @from).order(:date, :created_at).all
            @transactions_by_cat = @owner.transactions.joins(:balance_outs).where('date >= ? AND date <= ? AND for_acc = false', @from, @to).group(:type_id).select(
              :type_id, "sum(balance_outs.debit) as debit_sum", "sum(balance_outs.credit) as credit_sum"
            )
          elsif @house_id.present? # House is selected
            @transactions = @owner.transactions.where('date >= ? AND date <= ? AND house_id = ?', @from, @to, @house_id).order(
              :date, :created_at
            ).all
            @transactions_before = @owner.transactions.where('date < ? AND house_id = ?', @from, @house_id).order(
              :date, :created_at
            ).all
            @transactions_by_cat = @owner.transactions.joins(:balance_outs).where('date >= ? AND date <= ? AND for_acc = false AND house_id = ?', @from, @to, @house_id).group(:type_id).select(
              :type_id, "sum(balance_outs.debit) as debit_sum", "sum(balance_outs.credit) as credit_sum"
            )
          end
          type_rental_id = TransactionType.find_by(name_en: 'Rental').id
          @cr_rental = 0
          if @transactions.any?
            @cr_rental = @transactions.where(type_id: type_rental_id).joins(:balance_outs).sum(:credit)
          end
          @cr_prev_rental = 0
          if @transactions_before.any?
            @cr_prev_rental = @transactions_before.where(type_id: type_rental_id).joins(:balance_outs).sum(:credit)
          end
          @one_house = true
          @one_house = false if @owner.houses.count > 1
          today = Time.zone.now.in_time_zone('Bangkok')
          future_booking_ids = @owner.houses.joins(:bookings).where('bookings.start >?', today).pluck('bookings.id')
          future_booking_de = Booking.where(id: future_booking_ids).joins(transactions: :balance_outs).sum('balance_outs.debit')
          future_booking_cr = Booking.where(id: future_booking_ids).joins(transactions: :balance_outs).sum('balance_outs.credit')
          @bookings_prepayment = future_booking_de - future_booking_cr
          @view = 'owner'
        end
        # White balance
        if params[:commit] == 'Acc' && current_user.role?(%w[Admin Manager Accounting])
          @house_id = ''
          @transactions = Transaction.where('date >= ? AND date <= ? AND user_id = ?', @from, @to, @owner_id).order(
            :date, :created_at
          ).all
          @transactions_before = Transaction.where('date < ? AND user_id = ?', @from, @owner_id).all
          type_rental_id = TransactionType.find_by(name_en: 'Rental').id
          @view = 'accounting' if params[:commit] == 'Acc'
          session[:view] = @view
        end
      end
    end
  end

  def show; end

  # @route GET /transactions_docs (transactions_docs)
  def docs
    @from = params[:from]
    @to = params[:to]
    @owner = User.find(params[:view_user_id])
    @one_house = true
    @one_house = false if @owner.houses.count > 1
    @transactions = Transaction.where('date >= ? AND date <= ? AND user_id = ?', @from, @to, @owner.id).order(:date,
                                                                                                              :created_at).all
    if params[:type] == 'invoice'
      render template: 'transactions/invoice'
    elsif params[:type] == 'receipt'
      render template: 'transactions/receipt'
    end
  end

  # @route GET /transactions/new (new_transaction)
  def new
    if params[:tid].present?
      tid = params[:tid]
      old_transaction = Transaction.find(tid)
      @transaction = old_transaction.dup
      @transaction.date = nil
      @de_ow = old_transaction.balance_outs.sum(:debit)
      @cr_ow = old_transaction.balance_outs.sum(:credit)
      @de_co = old_transaction.balances.sum(:debit)
      @cr_co = old_transaction.balances.sum(:credit)
      @cr_ow -= @de_co
    else
      @transaction = Transaction.new
    end
    now = Time.zone.now.in_time_zone('Bangkok')
    @s3_direct_post = S3_BUCKET.presigned_post(
      key: "transactions/${filename}",
      success_action_status: '201',
      acl: 'public-read',
      content_type_starts_with: ""
    )
    if params[:user_id].present?
      owner = User.find(params[:user_id])
      @transaction.user_id = owner.id
      @transaction.house_id = owner.houses.first.id if owner.houses.count == 1
      @bookings = owner.houses.joins(:bookings).where('bookings.paid = ? AND bookings.status != ? AND bookings.status != ?', false, Booking.statuses[:block], Booking.statuses[:canceled]).select(
        'bookings.id', 'bookings.start', 'bookings.finish', 'houses.code'
      ).order('bookings.start')
    else
      @bookings = Booking.joins(:house).where('paid = ? AND status != ? AND status != ?', false, Booking.statuses[:block], Booking.statuses[:canceled]).select(
        'bookings.id', 'bookings.start', 'bookings.finish', 'houses.code'
      ).order('bookings.start')
    end
  end

  # @route GET /transactions/:id/edit (edit_transaction)
  def edit
    @de_ow = @transaction.balance_outs.sum(:debit)
    @cr_ow = @transaction.balance_outs.sum(:credit)
    @de_co = @transaction.balances.sum(:debit)
    @cr_co = @transaction.balances.sum(:credit)
    @bookings = []
    @s3_direct_post = S3_BUCKET.presigned_post(
      key: "transactions/${filename}",
      success_action_status: '201',
      acl: 'public-read',
      content_type_starts_with: ""
    )
    if @transaction.user
      owner = @transaction.user
      @bookings = owner.houses.joins(:bookings).where('(paid = ? AND status != ? AND status != ?) OR bookings.id = ?', false, Booking.statuses[:block], Booking.statuses[:canceled], @transaction.booking_id).select(
        'bookings.id', 'bookings.start', 'bookings.finish', 'houses.code'
      ).order('bookings.start')
    end
  end

  # @route POST /transactions (transactions)
  def create
    @transaction = Transaction.new(transaction_params)
    @transaction.set_owner_and_house
    respond_to do |format|
      if @transaction.save
        de_ow = params[:transaction][:de_ow].to_d
        cr_ow = params[:transaction][:cr_ow].to_d
        de_co = params[:transaction][:de_co].to_d
        cr_co = params[:transaction][:cr_co].to_d
        type = TransactionType.find(params[:transaction][:type_id]).name_en
        @transaction.write_to_balance(type, de_ow, cr_ow, de_co, cr_co)
        files = params['transaction']['files']
        unless files.nil?
          files.each do |f|
            @transaction.files.create!(url: f)
          end
        end
        files_to_show = params['transaction']['files_to_show']
        unless files_to_show.nil?
          files_to_show.each do |f|
            @transaction.files.find_by(url: f).update(show: true)
          end
        end
        if @transaction.errors.any?
          @transaction.destroy
          if params[:user_id].present?
            owner = User.find(params[:user_id])
            @transaction.user_id = owner.id
            @transaction.house_id = owner.houses.first.id if owner.houses.count == 1
            @bookings = owner.houses.joins(:bookings).where('bookings.paid = ? AND bookings.status != ? AND bookings.status != ?', false, Booking.statuses[:block], Booking.statuses[:canceled]).select(
              'bookings.id', 'bookings.start', 'bookings.finish', 'houses.code'
            ).order('bookings.start')
          else
            @bookings = Booking.joins(:house).where('paid = ? AND status != ? AND status != ?', false, Booking.statuses[:block], Booking.statuses[:canceled]).select(
              'bookings.id', 'bookings.start', 'bookings.finish', 'houses.code'
            ).order('bookings.start')
          end
          @s3_direct_post = S3_BUCKET.presigned_post(key: "transactions/${filename}", success_action_status: '201',
                                                     acl: 'public-read')
          render :new and return
        end
        @transaction.booking.update(paid: true) if params[:booking_fully_paid] == "true"
        format.html do
          redirect_to transactions_path(
            from: session[:from],
            to: session[:to],
            owner_id: session[:owner_id],
            house_id: session[:house_id],
            commit: session[:commit]
          ),
                      notice: 'Transaction was successfully created.' end
      else
        @de_ow = params[:transaction][:de_ow].to_d
        @cr_ow = params[:transaction][:cr_ow].to_d
        @de_co = params[:transaction][:de_co].to_d
        @cr_co = params[:transaction][:cr_co].to_d
        @bookings = []
        @s3_direct_post = S3_BUCKET.presigned_post(
          key: "transactions/${filename}",
          success_action_status: '201',
          acl: 'public-read',
          content_type_starts_with: ""
        )
        if params[:user_id].present?
          owner = User.find(params[:user_id])
          @bookings = owner.houses.joins(:bookings).where('bookings.paid = ? AND bookings.status != ? AND bookings.status != ?', false, Booking.statuses[:block], Booking.statuses[:canceled]).select(
            'bookings.id', 'bookings.start', 'bookings.finish', 'houses.code'
          ).order('bookings.start')
        else
          @bookings = Booking.joins(:house).where('paid = ? AND status != ? AND status != ?', false, Booking.statuses[:block], Booking.statuses[:canceled]).select(
            'bookings.id', 'bookings.start', 'bookings.finish', 'houses.code'
          ).order('bookings.start')
        end
        @houses_for_select = set_houses_for_select
        format.html { render :new }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # @route PATCH /transactions/:id (transaction)
  # @route PUT /transactions/:id (transaction)
  def update
    respond_to do |format|
      state_before = @transaction
      if @transaction.update(transaction_params)
        @transaction.set_owner_and_house
        @transaction.save
        de_ow = params[:transaction][:de_ow].to_d
        cr_ow = params[:transaction][:cr_ow].to_d
        de_co = params[:transaction][:de_co].to_d
        cr_co = params[:transaction][:cr_co].to_d
        type = TransactionType.find(params[:transaction][:type_id]).name_en
        @transaction.write_to_balance(type, de_ow, cr_ow, de_co, cr_co)
        files = params['transaction']['files']
        unless files.nil?
          files.each do |f|
            @transaction.files.create!(url: f)
          end
        end
        files_to_show = params['transaction']['files_to_show']
        unless files_to_show.nil?
          files_to_show.each do |f|
            @transaction.files.find_by(url: f).update(show: true)
          end
        end
        if @transaction.errors.any?
          @de_ow = @transaction.balance_outs.sum(:debit)
          @cr_ow = @transaction.balance_outs.sum(:credit)
          @de_co = @transaction.balances.sum(:debit)
          @cr_co = @transaction.balances.sum(:credit)
          @bookings = []
          @s3_direct_post = S3_BUCKET.presigned_post(
            key: "transactions/${filename}",
            success_action_status: '201',
            acl: 'public-read',
            content_type_starts_with: ""
          )
          if @transaction.user
            owner = @transaction.user
            @bookings = owner.houses.joins(:bookings).where('(paid = ? AND status != ? AND status != ?) OR bookings.id = ?', false, Booking.statuses[:block], Booking.statuses[:canceled], @transaction.booking_id).select(
              'bookings.id', 'bookings.start', 'bookings.finish', 'houses.code'
            ).order('bookings.start')
          end

          render :edit and return
        end

        @transaction.booking.update(paid: true) if params[:booking_fully_paid] == "true"
        format.html do
          redirect_to transactions_path(
            from: session[:from],
            to: session[:to],
            owner_id: session[:owner_id],
            house_id: session[:house_id],
            commit: session[:commit]
          ),
                      notice: 'Transaction was successfully updated.' end
        format.json { render :show, status: :ok, location: @transaction }
      else
        @de_ow = @transaction.balance_outs.sum(:debit)
        @cr_ow = @transaction.balance_outs.sum(:credit)
        @de_co = @transaction.balances.sum(:debit)
        @cr_co = @transaction.balances.sum(:credit)
        @bookings = []
        if @transaction.user
          owner = @transaction.user
          @bookings = owner.houses.joins(:bookings).where('(paid = ? AND status != ? AND status != ?) OR bookings.id = ?', false, Booking.statuses[:block], Booking.statuses[:canceled], @transaction.booking_id).select(
            'bookings.id', 'bookings.start', 'bookings.finish', 'houses.code'
          ).order('bookings.start')
        end
        @s3_direct_post = S3_BUCKET.presigned_post(
          key: "transactions/${filename}",
          success_action_status: '201',
          acl: 'public-read',
          content_type_starts_with: ""
        )
        format.html { render :edit }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # @route POST /transactions/update_invoice_ref (update_invoice_ref)
  def update_invoice_ref
    error = 'Need to select Owner' unless session[:view_user_id].present?
    if session[:from].to_date.month != session[:to].to_date.month
      error = 'Can update invoice ref_no only with in one month'
    end
    if error.present?
      redirect_to transactions_path(from: session[:from],
                                    to: session[:to],
                                    owner_id: session[:owner_id],
                                    house_id: session[:house_id],
                                    commit: session[:commit]),
                  notice: error
      return
    end
    # view_user_id = session[:view_user_id]
    # commit = session[:commit]
    @transactions = Transaction.joins(:balance_outs).where(
      'date >= ? AND date <= ? AND user_id = ? AND balance_outs.credit > 0',
      session[:from], session[:to], session[:view_user_id]
    ).all
    @transactions.each do |t|
      t.balances.where('debit > 0').update(ref_no: params[:ref_no])
      t.balance_outs.where('credit > 0').update(ref_no: params[:ref_no])
    end
    redirect_to transactions_path(from: session[:from],
                                  to: session[:to],
                                  owner_id: session[:owner_id],
                                  house_id: session[:house_id],
                                  commit: session[:commit]),
                notice: 'Ref no was successfully updated.'
  end

  # @route DELETE /transactions/:id (transaction)
  def destroy
    @transaction.destroy
    respond_to do |format|
      format.html do
        redirect_to transactions_path(
          from: session[:from],
          to: session[:to],
          owner_id: session[:owner_id],
          house_id: session[:house_id],
          commit: session[:commit]
        ),
                    notice: 'Transaction was successfully destroyed.' end
      # format.html { redirect_to transactions_url, notice: 'Transaction was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # @route GET /transaction_warnings (transaction_warnings)
  def warnings
    warning = ""
    type = params[:type]
    is_sum = params[:is_sum]
    date = params[:date]
    user_id = params[:user_id]
    field = params[:field]
    text = params[:text]
    if type == "text"
      if user_id.present?
        if field == "transaction_comment_en"
          ts = Transaction.where('date = ? AND user_id = ? AND comment_en ILIKE ? ', date, user_id,
                                 "%#{text}%")
        end
        if field == "transaction_comment_ru"
          ts = Transaction.where('date = ? AND user_id = ? AND comment_ru ILIKE ? ', date, user_id,
                                 "%#{text}%")
        end
      else
        if field == "transaction_comment_en"
          ts = Transaction.where('date = ? AND user_id IS NULL AND comment_en ILIKE ? ', date,
                                 "%#{text}%")
        end
        if field == "transaction_comment_ru"
          ts = Transaction.where('date = ? AND user_id IS NULL AND comment_ru ILIKE ? ', date,
                                 "%#{text}%")
        end
      end
      warning = "There is one more transaction with simillar name on this date" if !ts.nil? && ts.any?
    elsif type == "number"
      if user_id.present?
        if field == "transaction_de_ow"
          ts = Transaction.where('date = ?', date).joins(:balance_outs).where('balance_outs.debit = ?',
                                                                              text)
        end
        if field == "transaction_cr_ow"
          ts = Transaction.where('date = ?', date).joins(:balance_outs).where('balance_outs.credit = ?',
                                                                              text)
        end
        if field == "transaction_de_co"
          ts = Transaction.where('date = ?', date).joins(:balances).where('balances.debit = ?',
                                                                          text)
        end
      elsif field == "transaction_cr_co"
        ts = Transaction.where('date = ?', date).joins(:balances).where('balances.credit = ?',
                                                                        text)
      end
      if is_sum == 'true'
        warning = "There is one more transaction with same cr_co+de_co on this date" if !ts.nil? && ts.any?
      elsif !ts.nil? && ts.any?
        warning = "There is one more transaction with same amount on this date"
      end
    end
    render json: { field: field, warning: warning }
  end

  private

  def set_owners
    User.joins(:houses)
      .select(" users.id as owner_id,
                  houses.id as house_id,
                  houses.code as house_code,
                  houses.maintenance as house_maintenance,
                  users.name as owner_name,
                  users.surname as owner_surname ")
      .where.not('houses.balance_closed': true)
      .order('houses.code')
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_transaction
    @transaction = Transaction.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def transaction_params
    params.require(:transaction).permit(:date,
                                        :ref_no,
                                        :house_id,
                                        :type_id,
                                        :user_id,
                                        :booking_id,
                                        :comment_en,
                                        :comment_ru,
                                        :comment_inner,
                                        :cash,
                                        :hidden,
                                        :for_acc,
                                        :incomplite)
  end
end
