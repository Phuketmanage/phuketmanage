class TransactionsController < ApplicationController
  load_and_authorize_resource

  before_action :set_transaction, only: [:show, :edit, :update, :destroy]
  layout 'admin'
  # after_action :check_warnings, only: [:create, :update]

  # GET /transactions
  # GET /transactions.json
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
    if !@error.present?
      # Owner view
      if current_user.role?(['Owner']) || params[:commit] == 'Owner view'
        # Owner view for owner
        if current_user.role?(['Owner'])
          @owner = current_user
        # Owner view for management
        elsif params[:commit] == 'Owner view' && current_user.role?(['Admin','Manager','Accounting'])
          # if !params[:view_user_id].present?
          @houses_for_select = set_houses_for_select
          @view_user_id = params[:view_user_id].present? ? params[:view_user_id].to_i : nil
          @view_house_id = params[:view_house_id].present? ? params[:view_house_id].to_i : nil
          if @view_user_id && !@view_house_id.present?
            @view_house_id = User.find(@view_user_id).houses.where.not(balance_closed: true).last.id
          end
          if !@view_user_id && !@view_house_id
            @error = 'Owner or house should be selected for this type of view'
            return
          end
          # @view_user_id = params[:view_user_id]
          session[:view_user_id] = @view_user_id
          session[:view_house_id] = @view_house_id
          @owner = User.find(@view_user_id)
        end
        @locale = @owner.locale || 'en'
        @transactions = @owner.transactions.where('date >= ? AND date <= ?', @from, @to).order(:date, :created_at).all
        @transactions_before = @owner.transactions.where('date < ?', @from).order(:date, :created_at).all
        @transactions_by_cat = @owner.transactions.joins(:balance_outs).where('date >= ? AND date <= ? AND for_acc = false', @from, @to).group(:type_id).select(:type_id, "sum(balance_outs.debit) as debit_sum", "sum(balance_outs.credit) as credit_sum")
        type_rental_id = TransactionType.find_by(name_en: 'Rental').id
        @cr_rental = 0
        @cr_rental = @transactions.where(type_id: type_rental_id).joins(:balance_outs).sum(:credit) if @transactions.any?
        @cr_prev_rental = 0
        @cr_prev_rental = @transactions_before.where(type_id: type_rental_id).joins(:balance_outs).sum(:credit) if @transactions_before.any?
        @one_house = true
        @one_house = false if @owner.houses.count > 1
        today = Time.zone.now.in_time_zone('Bangkok')
        future_booking_ids = @owner.houses.joins(:bookings).where('bookings.start >?', today).pluck('bookings.id')
        future_booking_de = Booking.where(id: future_booking_ids).joins(transactions: :balance_outs).sum('balance_outs.debit')
        future_booking_cr = Booking.where(id: future_booking_ids).joins(transactions: :balance_outs).sum('balance_outs.credit')
        @bookings_prepayment = future_booking_de - future_booking_cr
        @view = 'owner'
        session[:commit] = params[:commit]
      # Accounting view
      elsif current_user.role?(['Admin','Manager','Accounting']) &&
      params[:commit] == 'Accounting view'
        @view_user_id = params[:view_user_id].present? ? params[:view_user_id].to_i : nil
        @view_house_id = params[:view_house_id].present? ? params[:view_house_id].to_i : nil
        @houses_for_select = set_houses_for_select
        if !@view_user_id && !@view_house_id
        # if !params[:view_house_id].present?
          @error = 'Owner or house should be selected for this type of view'
        else
          # @view_user_id = params[:view_user_id]
          # @view_user_id = House.find(params[:view_house_id]).owner.id
          owner = User.find(@view_user_id)
          @locale = owner.locale
          session[:view_user_id] = @view_user_id
          session[:view_house_id] = @view_house_id
          @transactions = Transaction.where('date >= ? AND date <= ? AND user_id = ?', @from, @to, @view_user_id).order(:date, :created_at).all
          @transactions_before = Transaction.where('date < ? AND user_id = ?', @from, @view_user_id).all
          # @transactions_by_cat = Transaction.joins(:balances).where('date >= ? AND date <= ? AND user_id = ?', @from, @to, @view_user_id).group(:type_id).select(:type_id, "sum(balances.debit) as debit_sum", "sum(balances.credit) as credit_sum")
          type_rental_id = TransactionType.find_by(name_en: 'Rental').id
          @view = 'accounting' if params[:commit] == 'Accounting view'
          session[:commit] = params[:commit]
          session[:view] = @view
        end
      # Company view
      elsif current_user.role?(['Admin','Manager','Accounting'])
        # @owners_for_select = set_owners_for_select
        @houses_for_select = set_houses_for_select
        @view_user_id = params[:view_user_id].present? ? params[:view_user_id].to_i : nil
        @view_house_id = params[:view_house_id].present? ? params[:view_house_id].to_i : nil
        if @view_user_id.present?
          # @view_user_id = params[:view_user_id]
          owner = User.find(@view_user_id)
          session[:view_user_id] = @view_user_id
          session[:view_house_id] = @view_house_id
          @transactions = Transaction.where('date >= ? AND date <= ? AND user_id = ?', @from, @to, @view_user_id).order(:date, :created_at).all
          @transactions_before = Transaction.where('date < ? AND user_id = ?', @from, @view_user_id).all
          @transactions_by_cat = Transaction.joins(:balances).where('date >= ? AND date <= ? AND user_id = ? AND for_acc = false', @from, @to, @view_user_id).group(:type_id).select(:type_id, "sum(balances.debit) as debit_sum", "sum(balances.credit) as credit_sum")
        else
          if current_user.role?(['Admin'])
            @transactions = Transaction.where('date >= ? AND date <= ?', @from, @to).order(:date, :created_at).all
            @transactions_before = Transaction.where('date < ?', @from).all
            @transactions_by_cat = Transaction.joins(:balances).where('date >= ? AND date <= ? AND for_acc = false', @from, @to).group(:type_id).select(:type_id, "sum(balances.debit) as debit_sum", "sum(balances.credit) as credit_sum")
          else
            salary = TransactionType.find_by(name_en:'Salary')
            @transactions = Transaction.where('date >= ? AND date <= ? AND type_id !=?', @from, @to, salary.id).order(:date, :created_at).all
            @transactions_before = Transaction.where('date < ?', @from).all
            @transactions_by_cat = Transaction.joins(:balances).where('date >= ? AND date <= ? AND type_id !=? AND for_acc = false', @from, @to, salary.id).group(:type_id).select(:type_id, "sum(balances.debit) as debit_sum", "sum(balances.credit) as credit_sum")
          end
          session.delete(:view_user_id)
        end
        @view = 'company'
        session[:commit] = params[:commit]
        session[:view] = @view
      else
        @error = 'No action programmed for this request'
      end
    end
  end

  # GET /transactions/1
  # GET /transactions/1.json
  def show
  end

  def docs
    @from = params[:from]
    @to = params[:to]
    @owner = User.find(params[:view_user_id])
    @one_house = true
    @one_house = false if @owner.houses.count > 1
    @transactions = Transaction.where('date >= ? AND date <= ? AND user_id = ?', @from, @to, @owner.id).order(:date, :created_at).all
    if params[:type] == 'invoice'
      render template: 'transactions/invoice'
    elsif params[:type] == 'receipt'
      render template: 'transactions/receipt'
    end
  end

  # GET /transactions/new
  def new

    unless params[:tid].present?
      @transaction = Transaction.new
    else
      tid = params[:tid]
      old_transaction = Transaction.find(tid)
      @transaction = old_transaction.dup
      @transaction.date = nil
      @de_ow = old_transaction.balance_outs.sum(:debit)
      @cr_ow = old_transaction.balance_outs.sum(:credit)
      @de_co = old_transaction.balances.sum(:debit)
      @cr_co = old_transaction.balances.sum(:credit)
      @cr_ow -= @de_co
    end
    now = Time.zone.now.in_time_zone('Bangkok')
    @s3_direct_post = S3_BUCKET.presigned_post(
      key: "transactions/${filename}",
      success_action_status: '201',
      acl: 'public-read',
      content_type_starts_with: "")
    if params[:user_id].present?
      owner = User.find(params[:user_id])
      @transaction.user_id = owner.id
      if owner.houses.count == 1
        @transaction.house_id = owner.houses.first.id
      end
      @bookings = owner.houses.joins(:bookings).where('bookings.paid = ? AND bookings.status != ? AND bookings.status != ?', false, Booking.statuses[:block], Booking.statuses[:canceled]).select('bookings.id', 'bookings.start', 'bookings.finish', 'houses.code').order('bookings.start')
    else
      @bookings = Booking.joins(:house).where('paid = ? AND status != ? AND status != ?', false, Booking.statuses[:block], Booking.statuses[:canceled]).select('bookings.id', 'bookings.start', 'bookings.finish', 'houses.code').order('bookings.start')
    end
  end

  # GET /transactions/1/edit
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
      content_type_starts_with: "")
    if @transaction.user
      owner = @transaction.user
      @bookings = owner.houses.joins(:bookings).where('(paid = ? AND status != ? AND status != ?) OR bookings.id = ?', false, Booking.statuses[:block], Booking.statuses[:canceled], @transaction.booking_id).select('bookings.id', 'bookings.start', 'bookings.finish', 'houses.code').order('bookings.start')
    end
  end

  # POST /transactions
  # POST /transactions.json
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
        if !files.nil?
          files.each do |f|
            @transaction.files.create!(url: f)
          end
        end
        files_to_show = params['transaction']['files_to_show']
        if !files_to_show.nil?
          files_to_show.each do |f|
            @transaction.files.find_by(url: f).update_attributes(show: true)
          end
        end
        if @transaction.errors.any?
          @transaction.destroy
          if params[:user_id].present?
            owner = User.find(params[:user_id])
            @transaction.user_id = owner.id
            if owner.houses.count == 1
              @transaction.house_id = owner.houses.first.id
            end
            @bookings = owner.houses.joins(:bookings).where('bookings.paid = ? AND bookings.status != ? AND bookings.status != ?', false, Booking.statuses[:block], Booking.statuses[:canceled]).select('bookings.id', 'bookings.start', 'bookings.finish', 'houses.code').order('bookings.start')
          else
            @bookings = Booking.joins(:house).where('paid = ? AND status != ? AND status != ?', false, Booking.statuses[:block], Booking.statuses[:canceled]).select('bookings.id', 'bookings.start', 'bookings.finish', 'houses.code').order('bookings.start')
          end
          @s3_direct_post = S3_BUCKET.presigned_post(key: "transactions/${filename}", success_action_status: '201', acl: 'public-read')
          render :new and return
        end
        if params[:booking_fully_paid] == "true"
          @transaction.booking.update(paid: true)
        end
        format.html { redirect_to transactions_path(
                                    from: session[:from],
                                    to: session[:to],
                                    view_user_id: session[:view_user_id],
                                    view_house_id: session[:view_house_id],
                                    commit: session[:commit]),
                                    notice: 'Transaction was successfully created.' }
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
          content_type_starts_with: "")
        if params[:user_id].present?
          owner = User.find(params[:user_id])
          @bookings = owner.houses.joins(:bookings).where('bookings.paid = ? AND bookings.status != ? AND bookings.status != ?', false, Booking.statuses[:block], Booking.statuses[:canceled]).select('bookings.id', 'bookings.start', 'bookings.finish', 'houses.code').order('bookings.start')
        else
          @bookings = Booking.joins(:house).where('paid = ? AND status != ? AND status != ?', false, Booking.statuses[:block], Booking.statuses[:canceled]).select('bookings.id', 'bookings.start', 'bookings.finish', 'houses.code').order('bookings.start')
        end
        @houses_for_select = set_houses_for_select
        format.html { render :new }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /transactions/1
  # PATCH/PUT /transactions/1.json
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
        if !files.nil?
          files.each do |f|
            @transaction.files.create!(url: f)
          end
        end
        files_to_show = params['transaction']['files_to_show']
        if !files_to_show.nil?
          files_to_show.each do |f|
            @transaction.files.find_by(url: f).update_attributes(show: true)
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
            content_type_starts_with: "")
          if @transaction.user
            owner = @transaction.user
            @bookings = owner.houses.joins(:bookings).where('(paid = ? AND status != ? AND status != ?) OR bookings.id = ?', false, Booking.statuses[:block], Booking.statuses[:canceled], @transaction.booking_id).select('bookings.id', 'bookings.start', 'bookings.finish', 'houses.code').order('bookings.start')
          end

          render :edit and return
        end

        if params[:booking_fully_paid] == "true"
          @transaction.booking.update(paid: true)
        end
        format.html { redirect_to transactions_path(
                                    from: session[:from],
                                    to: session[:to],
                                    view_user_id: session[:view_user_id],
                                    commit: session[:commit]),
                                    notice: 'Transaction was successfully updated.' }
        format.json { render :show, status: :ok, location: @transaction }
      else
        @de_ow = @transaction.balance_outs.sum(:debit)
        @cr_ow = @transaction.balance_outs.sum(:credit)
        @de_co = @transaction.balances.sum(:debit)
        @cr_co = @transaction.balances.sum(:credit)
        @bookings = []
        if @transaction.user
          owner = @transaction.user
          @bookings = owner.houses.joins(:bookings).where('(paid = ? AND status != ? AND status != ?) OR bookings.id = ?', false, Booking.statuses[:block], Booking.statuses[:canceled], @transaction.booking_id).select('bookings.id', 'bookings.start', 'bookings.finish', 'houses.code').order('bookings.start')
        end
        @s3_direct_post = S3_BUCKET.presigned_post(
          key: "transactions/${filename}",
          success_action_status: '201',
          acl: 'public-read',
          content_type_starts_with: "")
        format.html { render :edit }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_invoice_ref
    if !session[:view_user_id].present?
      error = 'Need to select Owner'
    end
    if session[:from].to_date.month != session[:to].to_date.month
      error = 'Can update invoice ref_no only with in one month'
    end
    if error.present?
      redirect_to transactions_path(from: session[:from],
                                    to: session[:to],
                                    view_user_id: session[:view_user_id],
                                    commit: session[:commit]),
                                    notice: error
      return
    end
    # view_user_id = session[:view_user_id]
    # commit = session[:commit]
    @transactions = Transaction.joins(:balance_outs).where(
      'date >= ? AND date <= ? AND user_id = ? AND balance_outs.credit > 0',
      session[:from], session[:to], session[:view_user_id]).all
    @transactions.each do |t|
      t.balances.where('debit > 0').update(ref_no: params[:ref_no])
      t.balance_outs.where('credit > 0').update(ref_no: params[:ref_no])
    end
    redirect_to transactions_path(from: session[:from],
                                  to: session[:to],
                                  view_user_id: session[:view_user_id],
                                  commit: session[:commit]),
                                  notice: 'Ref no was successfully updated.'

  end

  # DELETE /transactions/1
  # DELETE /transactions/1.json
  def destroy
    @transaction.destroy
    respond_to do |format|
      format.html { redirect_to transactions_path(
                                    from: session[:from],
                                    to: session[:to],
                                    view_user_id: session[:view_user_id],
                                    commit: session[:commit]),
                                    notice: 'Transaction was successfully destroyed.' }
      # format.html { redirect_to transactions_url, notice: 'Transaction was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def warnings
    warning = ""
    type = params[:type]
    is_sum = params[:is_sum]
    date = params[:date]
    user_id = params[:user_id]
    field = params[:field]
    text = params[:text]
    if type == "text"
      if !user_id.present?
        ts = Transaction.where('date = ? AND user_id IS NULL AND comment_en ILIKE ? ', date, "%#{text}%") if field == "transaction_comment_en"
        ts = Transaction.where('date = ? AND user_id IS NULL AND comment_ru ILIKE ? ', date, "%#{text}%") if field == "transaction_comment_ru"
      else
        ts = Transaction.where('date = ? AND user_id = ? AND comment_en ILIKE ? ', date, user_id, "%#{text}%") if field == "transaction_comment_en"
        ts = Transaction.where('date = ? AND user_id = ? AND comment_ru ILIKE ? ', date, user_id, "%#{text}%") if field == "transaction_comment_ru"
      end
      warning = "There is one more transaction with simillar name on this date" if !ts.nil? && ts.any?
    elsif type == "number"
      if !user_id.present?
        ts = Transaction.where('date = ?', date).joins(:balances).where('balances.credit = ?', text) if field == "transaction_cr_co"
      else
        ts = Transaction.where('date = ?', date).joins(:balance_outs).where('balance_outs.debit = ?', text) if field == "transaction_de_ow"
        ts = Transaction.where('date = ?', date).joins(:balance_outs).where('balance_outs.credit = ?', text) if field == "transaction_cr_ow"
        ts = Transaction.where('date = ?', date).joins(:balances).where('balances.debit = ?', text) if field == "transaction_de_co"
      end
      if is_sum == 'true'
        warning = "There is one more transaction with same cr_co+de_co on this date" if !ts.nil? && ts.any?
      else
        warning = "There is one more transaction with same amount on this date" if !ts.nil? && ts.any?
      end
    end
    render json: { field: field, warning: warning }
  end

  private
    # def set_owners_for_select
    #   User.joins(:houses)
    #     .select(" users.id,
    #               users.name,
    #               users.surname")
    #     .where.not('houses.balance_closed': true)
    #     .order('users.name')
    #     .group('users.id')
    #     .map{|o| [o.id, "#{o.name} #{o.surname}"]}
    #     .to_h

    # end

    def set_houses_for_select
      User.joins(:houses)
        .select(" users.id as owner_id,
                  houses.id as house_id,
                  houses.code as house_code,
                  users.name as owner_name,
                  users.surname as owner_surname ")
        .where.not('houses.balance_closed': true)
        .order('houses.code')
        .map{|h| [
          h.house_id,
          {text: "#{h.house_code} (#{h.owner_name} #{h.owner_surname})", user_id: h.owner_id}]}
        .to_h
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
                                          :hidden,
                                          :for_acc,
                                          :incomplite)
    end

end
