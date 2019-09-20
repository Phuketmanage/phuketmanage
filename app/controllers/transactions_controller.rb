class TransactionsController < ApplicationController
  load_and_authorize_resource

  before_action :set_transaction, only: [:show, :edit, :update, :destroy]
  layout 'admin'

  # GET /transactions
  # GET /transactions.json
  def index
    from = Time.zone.now.in_time_zone('Bangkok').beginning_of_month.to_date
    to = Time.zone.now.in_time_zone('Bangkok').end_of_month.to_date

    if params[:user_id].present?
      @transactions = Transaction.where('date >= ? AND date <= ? AND user_id = ?', from, to, params[:user_id]).order(date: :desc, created_at: :desc).all
      @view = 'company' if params[:commit] == 'Company view'
      @view = 'owner' if params[:commit] == 'Owner view'
      @view = 'accounting' if params[:commit] == 'Accounting view'
    else
      @transactions = Transaction.where('date >= ? AND date <= ?', from, to).order(date: :desc, created_at: :desc).all
      @view = 'company'
    end
    # @transactions.order(date: :desc, created_at: :desc)
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
  end

  # POST /transactions
  # POST /transactions.json
  def create
    @transaction = Transaction.new(transaction_params)
    @transaction.set_owner
    respond_to do |format|
      if @transaction.save
        de_ow = params[:transaction][:inc_owner].to_d
        cr_ow = params[:transaction][:exp_owner].to_d
        de_co = params[:transaction][:inc_company].to_d
        cr_co = params[:transaction][:exp_company].to_d
        type = TransactionType.find(params[:transaction][:type_id]).name_en
        @transaction.prepare(type, de_ow, cr_ow, de_co, cr_co)
        if @transaction.errors.any?
          @transaction.destroy
          render :new and return
        end
        format.html { redirect_to transactions_path, notice: 'Transaction was successfully created.' }
        # format.json { render :show, status: :created, location: @transaction }
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
        format.html { redirect_to @transaction, notice: 'Transaction was successfully updated.' }
        format.json { render :show, status: :ok, location: @transaction }
      else
        format.html { render :edit }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
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
      params.require(:transaction).permit(:date, :ref_no, :house_id, :type_id, :user_id, :comment_en, :comment_ru, :comment_inner)
    end
end
