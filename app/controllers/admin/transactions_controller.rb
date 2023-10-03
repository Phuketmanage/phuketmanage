require 'csv'

class Admin::TransactionsController < AdminController
  verify_authorized
  before_action :set_transaction, only: %i[show edit update destroy]

  # @route GET /transactions (transactions)
  # @route GET /balance (balance_front)
  def index
    authorize!
    @from = params[:from]
    @to = params[:to]
    session[:from] = params[:from]
    session[:to] = params[:to]
    if !@from.present? && !@to.present?
      @from = Date.current.beginning_of_month
      @to = Date.current.end_of_month
    elsif !@from.present? || !@to.present?
      @error = 'Both dates should be selected'
    end

    @owner_id = params[:owner_id].present? ? params[:owner_id].to_i : nil
    @houses_count = 0
    @houses_count = User.find(@owner_id).houses.count if @owner_id.present?
    # @house_id = ['unlinked', nil].include?(params[:house_id]) ? params[:house_id] : params[:house_id].to_i
    # byebug
    # byebug
    if ["unlinked", nil].include?(params[:house_id])
      @house_id = params[:house_id]
    elsif params[:house_id].to_i > 0
      @house_id = params[:house_id].to_i
    end
    @owners = set_owners
    @houses = []
    unless @error.present?
      # Balance of company
      if @owner_id.nil? &&
         current_user.role?(%w[Admin Manager Accounting])
        # Gray balance
        if params[:commit] != 'Acc'
          @transactions = Transaction.full(@from, @to)
          @transactions_before = Transaction.before(@from)
          @transactions_by_cat = Transaction.by_cat(@from, @to)
          if !current_user.role?(['Admin'])
            filter_ids = TransactionType.find_by(name_en: 'Salary')
            @transactions = @transactions.filtered(filter_ids)
            @transactions_before = @transactions_before.filtered(filter_ids)
            @transactions_by_cat = @transactions_by_cat.filtered(filter_ids)
          end
          @type = 'full'
        # White balance
        elsif params[:commit] == 'Acc'
          @transactions = Transaction.acc(@from, @to)
          @transactions_before = Transaction.acc_before(@from)
          if !current_user.role?(['Admin'])
            filter_ids = TransactionType.find_by(name_en: 'Salary')
            @transactions = @transactions.filtered(filter_ids)
            @transactions_before = @transactions_before.filtered(filter_ids)
          end
          @type = 'acc'
        end
        @view = 'company'
        session.delete(:owner_id)
        session[:commit] = params[:commit]
        session[:view] = @view
      # White balance
      # Balance of selected owner
      elsif !@owner_id.nil? || current_user.role?(['Owner'])
        if current_user.role?(['Owner'])
          @owner = current_user
        # Owner view for management
        elsif current_user.role?(%w[Admin Manager Accounting])
          session[:owner_id] = @owner_id
          session[:house_id] = @house_id
          @owner = User.find(@owner_id)
        end
        @houses = @owner.houses.active.select(:id, :code)
        session[:commit] = params[:commit]
        # Gray balance (owner can see only this)
        if params[:commit] != 'Acc'
          @transactions, @transactions_before, @transactions_by_cat = owner_transactions(@owner, @from, @to, @house_id)
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
          today = Time.current
          future_booking_ids = @owner.houses.joins(:bookings).where('bookings.start >?', today).pluck('bookings.id')
          future_booking_de = Booking.where(id: future_booking_ids).joins(transactions: :balance_outs).sum('balance_outs.debit')
          future_booking_cr = Booking.where(id: future_booking_ids).joins(transactions: :balance_outs).sum('balance_outs.credit')
          @bookings_prepayment = future_booking_de - future_booking_cr
          @view = 'owner'
        end
        # White balance
        if params[:commit] == 'Acc' && current_user.role?(%w[Admin Manager Accounting])
          @house_id = ''
          @transactions = Transaction.full_acc_for_owner(@from, @to, @owner_id)
          @transactions_before = Transaction.before_acc_for_owner(@from, @owner_id)
          type_rental_id = TransactionType.find_by(name_en: 'Rental').id
          @view = 'accounting' if params[:commit] == 'Acc'
          session[:view] = @view
        end
      end
    end
    respond_to do |format|
      format.html
      format.csv do
        response.headers['Content-Type'] = 'text/csv'
        response.headers['Content-Disposition'] = "attachment; filename=transactions.csv"
      end
    end
  end

  def show
    authorize!
  end

  # @route GET /transactions_docs (transactions_docs)
  def docs
    authorize!
    @from = params[:from]
    @to = params[:to]
    @owner = User.find(params[:view_user_id])
    @one_house = true
    @one_house = false if @owner.houses.count > 1
    @transactions = Transaction.where('date >= ? AND date <= ? AND user_id = ?', @from, @to, @owner.id).order(:date,
                                                                                                              :created_at).all
    if params[:type] == 'invoice'
      render template: 'admin/transactions/invoice'
    elsif params[:type] == 'receipt'
      render template: 'admin/transactions/receipt'
    end
  end

  # @route GET /transactions/new (new_transaction)
  def new
    authorize!
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
    now = Time.current
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
      if params[:house_id].present? && (params[:house_id].to_i > 0)
        @house = House.find(params[:house_id])
        @transaction.house_id = @house.id
      end
      @bookings = owner.unpaid_bookings
    else
      @bookings = Booking.unpaid
    end
  end

  # @route GET /transactions/:id/edit (edit_transaction)
  def edit
    authorize! @transaction
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
      @bookings = owner.unpaid_bookings(@transaction.booking_id)
    end
  end

  # @route POST /transactions (transactions)
  def create
    authorize!
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
            @bookings = owner.unpaid_bookings
          else
            @bookings = Booking.unpaid
          end
          @s3_direct_post = S3_BUCKET.presigned_post(key: "transactions/${filename}", success_action_status: '201',
                                                     acl: 'public-read')
          render :new and return
        end
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
          @bookings = owner.unpaid_bookings
        else
          @bookings = Booking.unpaid
        end
        format.html { render :new }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # @route PATCH /transactions/:id (transaction)
  # @route PUT /transactions/:id (transaction)
  def update
    authorize! @transaction
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
            @bookings = owner.unpaid_bookings(@transaction.booking_id)
          end

          render :edit and return
        end

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
          @bookings = owner.unpaid_bookings(@transaction.booking_id)
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
    authorize!
    error = 'Need to select Owner' unless session[:owner_id].present?
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
    authorize! @transaction
    @transaction.destroy
    @transaction.booking.toggle_status if !@transaction.booking.nil?
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
    authorize!
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

  # @route GET /transaction_raw_for_acc (transaction_raw_for_acc)
  def raw_for_acc
    authorize!
    @from = params[:from]
    @to = params[:to]
    @owner_id = params[:owner_id]
    @owner = User.find(@owner_id)
    @transactions = Transaction.where('date >= ? AND date <= ? AND user_id = ? AND hidden = ?', @from, @to, @owner_id, false).order(
      :date, :created_at
    ).all
  end

  private

  def owner_transactions(owner, from, to, house_id)
    transactions = owner.transactions.full(from, to)
    transactions_before = owner.transactions.before(from)
    transactions_by_cat = owner.transactions.by_cat_for_owner(from, to)
    case house_id
    when nil, 0 # All houses
      [transactions, transactions_before, transactions_by_cat]
    when 'unlinked' # Unlinked
      transactions = transactions.unlinked
      transactions_before = transactions_before.unlinked
      transactions_by_cat = transactions_by_cat.unlinked
    else # House selected
      transactions = transactions.for_house(house_id)
      transactions_before = transactions_before.for_house(house_id)
      transactions_by_cat = transactions_by_cat.for_house(house_id)
    end
    [transactions, transactions_before, transactions_by_cat]
  end

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
