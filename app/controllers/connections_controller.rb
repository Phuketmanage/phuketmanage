class ConnectionsController < ApplicationController
  load_and_authorize_resource

  before_action :set_house

  def create
    @connection = @house.connections.build(connection_params)
    if @connection.save
      redirect_to edit_house_path(@house.number), notice: 'Connection was successfully created.'
    else
      @owners = User.with_role('Owner')
      @types = HouseType.all
      @connections = @house.connections
      redirect_to edit_house_path(@house.number), notice: @connection.errors.full_messages
    end

  end

  def destroy
    @connection = Connection.find(params[:id])
    @connection.destroy
    redirect_to edit_house_path(@house.number), notice: 'Connection was successfully deleted.'
  end

  private
    def set_house
      @house = House.find_by(number: params[:house_id])
    end

    def connection_params
      params.require(:connection).permit(:house_id, :source_id, :link)
    end


end
