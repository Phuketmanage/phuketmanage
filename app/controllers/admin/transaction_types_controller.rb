class Admin::TransactionTypesController < AdminController
  load_and_authorize_resource

  before_action :set_transaction_type, only: %i[show edit update destroy]

  # @route GET /transaction_types (transaction_types)
  def index
    @transaction_types = TransactionType.all.order(:name_en)
  end

  # @route GET /transaction_types/:id (transaction_type)
  def show; end

  # @route GET /transaction_types/new (new_transaction_type)
  def new
    @transaction_type = TransactionType.new
  end

  # @route GET /transaction_types/:id/edit (edit_transaction_type)
  def edit; end

  # @route POST /transaction_types (transaction_types)
  def create
    @transaction_type = TransactionType.new(transaction_type_params)

    respond_to do |format|
      if @transaction_type.save
        format.html { redirect_to transaction_types_url, notice: 'Transaction type was successfully created.' }
        format.json { render :show, status: :created, location: @transaction_type }
      else
        format.html { render :new }
        format.json { render json: @transaction_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # @route PATCH /transaction_types/:id (transaction_type)
  # @route PUT /transaction_types/:id (transaction_type)
  def update
    respond_to do |format|
      if @transaction_type.update(transaction_type_params)
        format.html { redirect_to @transaction_type, notice: 'Transaction type was successfully updated.' }
        format.json { render :show, status: :ok, location: @transaction_type }
      else
        format.html { render :edit }
        format.json { render json: @transaction_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # @route DELETE /transaction_types/:id (transaction_type)
  def destroy
    @transaction_type.destroy
    respond_to do |format|
      format.html { redirect_to transaction_types_url, notice: 'Transaction type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_transaction_type
    @transaction_type = TransactionType.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def transaction_type_params
    params.require(:transaction_type).permit(:name_en,
                                             :name_ru,
                                             :debit_company,
                                             :credit_company,
                                             :debit_owner,
                                             :credit_owner,
                                             :admin_only)
  end
end
