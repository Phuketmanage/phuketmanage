class TodosController < ApplicationController
  load_and_authorize_resource

  before_action :set_todo, only: [:show, :edit, :update, :destroy]
  layout 'admin'

  # GET /todos
  # GET /todos.json
  def index
    @todo = Todo.new
    if current_user.role? :admin
      if params[:closed].present?
        @todos = Todo.where.not(closed: nil).order(closed: :desc).all
      else
        @todos = Todo.where(closed: nil).order(:plan).all
      end
    else
      if params[:closed].present?
        @todos = current_user.todos.where.not(closed: nil).order(closed: :desc).all
      else
        @todos = current_user.todos.where(closed: nil).order(:plan).all
      end
    end
  end

  # GET /todos/1
  # GET /todos/1.json
  def show
  end

  # GET /todos/new
  def new
    @todo = Todo.new
  end

  # GET /todos/1/edit
  def edit
  end

  # POST /todos
  # POST /todos.json
  def create
    @todo = Todo.new(todo_params)
    @todo.creator_id = current_user.id
    # byebug
    respond_to do |format|
      if @todo.save
        format.html { redirect_to todos_path, notice: 'Todo was successfully created.' }
        format.json { render  json: @todo,
                              status: :ok }
      else
        format.html { render  :new }
        format.json { render  json: @todo.errors,
                              status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /todos/1
  # PATCH/PUT /todos/1.json
  def update
    if params[:done].present?
      @todo_status_toggled = true
      @todo.closed =Time.now.in_time_zone('Bangkok').to_date if params[:done] == 'true'
      @todo.closed = nil if params[:done] == 'false'
      @todo.save
      return
    end

    respond_to do |format|
      if @todo.update(todo_params)
        format.html { redirect_to todos_path, notice:  'Todo was successfully updated.' }
        format.json { render :index, status: :ok, location: @todo }
        format.js
      else
        format.html { render :edit }
        format.json { render json: @todo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /todos/1
  # DELETE /todos/1.json
  def destroy
      @todo.destroy
      respond_to do |format|
        format.html { redirect_to todos_url, notice:  'Todo was successfully destroyed.' }
        format.json { head :no_content }
      end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_todo
      @todo = Todo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def todo_params
      params.require(:todo).permit(
                                  :user_id,
                                  :date,
                                  :plan,
                                  :closed,
                                  :job,
                                  :comment )
    end
end
