class TransactionsController < ApplicationController
  load_and_authorize_resource

  before_action :set_transaction, only: [:show, :edit, :update, :destroy]
  layout 'admin'

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
      if current_user.role?(['Owner'])
        @locale = current_user.locale
        @transactions = current_user.transactions.where('date >= ? AND date <= ?', @from, @to).order(:date, :created_at).all
        @transactions_before = current_user.transactions.where('date < ?', @from).order(:date, :created_at).all
        @transactions_by_cat = current_user.transactions.joins(:balance_outs).where('date >= ? AND date <= ?', @from, @to).group(:type_id).select(:type_id, "sum(balance_outs.debit) as debit_sum", "sum(balance_outs.credit) as credit_sum")
        type_rental_id = TransactionType.find_by(name_en: 'Rental').id
        @cr_rental = 0
        @cr_rental = @transactions.where(type_id: type_rental_id).joins(:balance_outs).sum(:credit) if @transactions.any?
        @cr_prev_rental = 0
        @cr_prev_rental = @transactions_before.where(type_id: type_rental_id).joins(:balance_outs).sum(:credit) if @transactions_before.any?
        @one_house = true
        @one_house = false if current_user.houses.count > 1
      elsif current_user.role?(['Admin','Manager','Accounting']) &&
      params[:view_user_id].present?
        @view_user_id = params[:view_user_id]
        owner = User.find(@view_user_id)
        @locale = owner.locale
        session[:view_user_id] = params[:view_user_id]
        @transactions = Transaction.where('date >= ? AND date <= ? AND user_id = ?', @from, @to, @view_user_id).order(:date, :created_at).all
        @transactions_before = Transaction.where('date < ? AND user_id = ?', @from, @view_user_id).all
        if params[:commit] == 'Owner view'
          @transactions_by_cat = Transaction.joins(:balance_outs).where('date >= ? AND date <= ? AND user_id = ?', @from, @to, @view_user_id).group(:type_id).select(:type_id, "sum(balance_outs.debit) as debit_sum", "sum(balance_outs.credit) as credit_sum")
        else
          @transactions_by_cat = Transaction.joins(:balances).where('date >= ? AND date <= ? AND user_id = ?', @from, @to, @view_user_id).group(:type_id).select(:type_id, "sum(balances.debit) as debit_sum", "sum(balances.credit) as credit_sum")
        end
        type_rental_id = TransactionType.find_by(name_en: 'Rental').id
        @cr_rental = 0
        @cr_rental = @transactions.where(type_id: type_rental_id).joins(:balance_outs).sum(:credit) if @transactions.any?
        @cr_prev_rental = 0
        @cr_prev_rental = @transactions_before.where(type_id: type_rental_id).joins(:balance_outs).sum(:credit) if @transactions_before.any?
        @view = 'company' if params[:commit] == 'Company view'
        @view = 'owner' if params[:commit] == 'Owner view'
        @owner_front_view = true if params[:commit] == 'Owner front view'
        @view = 'accounting' if params[:commit] == 'Accounting view'
        session[:commit] = params[:commit]
        session[:view] = @view
        @one_house = true
        @one_house = false if owner.houses.count > 1
      elsif current_user.role?(['Admin','Manager','Accounting'])
        if current_user.role?(['Admin'])
          @transactions = Transaction.where('date >= ? AND date <= ?', @from, @to).order(:date, :created_at).all
          @transactions_before = Transaction.where('date < ?', @from).all
          @transactions_by_cat = Transaction.joins(:balances).where('date >= ? AND date <= ?', @from, @to).group(:type_id).select(:type_id, "sum(balances.debit) as debit_sum", "sum(balances.credit) as credit_sum")
        else
          salary = TransactionType.find_by(name_en:'Salary')
          @transactions = Transaction.where('date >= ? AND date <= ? AND type_id !=?', @from, @to, salary.id).order(:date, :created_at).all
          @transactions_before = Transaction.where('date < ?', @from).all
          @transactions_by_cat = Transaction.joins(:balances).where('date >= ? AND date <= ? AND type_id !=?', @from, @to, salary.id).group(:type_id).select(:type_id, "sum(balances.debit) as debit_sum", "sum(balances.credit) as credit_sum")
        end
        @view = 'company'
        session.delete(:view_user_id)
        session[:commit] = params[:commit]
        session[:view] = @view
      end
    end
  end

  # GET /transactions/1
  # GET /transactions/1.json
  def show
  end

  # GET /transactions/new
  def new
    @transaction = Transaction.new
  end

  # GET /transactions/1/edit
  def edit
    @de_ow = @transaction.balance_outs.sum(:debit)
    @cr_ow = @transaction.balance_outs.sum(:credit)
    @de_co = @transaction.balances.sum(:debit)
    @cr_co = @transaction.balances.sum(:credit)
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
        if @transaction.errors.any?
          @transaction.destroy
          render :new and return
        end
        if params[:booking_fully_paid] == "true"
          @transaction.booking.update(paid: true)
        end
        format.html { redirect_to transactions_path(
                                    from: session[:from],
                                    to: session[:to],
                                    view_user_id: session[:view_user_id],
                                    commit: session[:commit]),
                                    notice: 'Transaction was successfully created.' }
      else
        format.html { render :new }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /transactions/1
  # PATCH/PUT /transactions/1.json
  def update
    respond_to do |format|

      if @transaction.update(transaction_params)
        @transaction.set_owner_and_house
        @transaction.save
        de_ow = params[:transaction][:de_ow].to_d
        cr_ow = params[:transaction][:cr_ow].to_d
        de_co = params[:transaction][:de_co].to_d
        cr_co = params[:transaction][:cr_co].to_d
        type = TransactionType.find(params[:transaction][:type_id]).name_en
        @transaction.write_to_balance(type, de_ow, cr_ow, de_co, cr_co)
        if @transaction.errors.any?
          @de_ow = @transaction.balance_outs.sum(:debit)
          @cr_ow = @transaction.balance_outs.sum(:credit)
          @de_co = @transaction.balances.sum(:debit)
          @cr_co = @transaction.balances.sum(:credit)
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
    @transactions = Transaction.joins(:balances).where(
      'date >= ? AND date <= ? AND user_id = ? AND balances.debit > 0',
      session[:from], session[:to], session[:view_user_id]).all
    @transactions.each do |t|
      t.balances.update(ref_no: params[:ref_no])
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
      format.html { redirect_to transactions_url, notice: 'Transaction was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
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
                                          :for_acc)
    end
end
