class Admin::ConnectionsController < ApplicationController
  load_and_authorize_resource

  # before_action :set_house, only: :create

  # @route POST (/:locale)/connections {locale: nil} (connections)
  def create
    @house = House.find_by(number: params[:hid])
    @connection = @house.connections.build(connection_params)
    if @connection.save
      redirect_to edit_admin_house_path(@house.number), notice: 'Connection was successfully created.'
    else
      @owners = User.with_role('Owner')
      @types = HouseType.all
      @connections = @house.connections
      redirect_to edit_admin_house_path(@house.number), notice: @connection.errors.full_messages
    end
  end

  # @route DELETE (/:locale)/connections/:id {locale: nil} (connection)
  def destroy
    @connection = Connection.find(params[:id])
    hid = @connection.house.number
    @connection.destroy
    redirect_to edit_admin_house_path(hid), notice: 'Connection was successfully deleted.'
  end

  private

  # def set_house

  # end

  def connection_params
    params.require(:connection).permit(:house_id, :source_id, :link)
  end
end
