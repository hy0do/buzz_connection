class MessageRoomsController < ApplicationController
  before_action :user_login!

  def index
    @rooms = MessageRoom.where(id: current_user.message_rooms).includes(:users)
  end

  def show
    @room = current_user.message_rooms.includes(messages: :user).find(params[:id])
    gon.room = ActiveModelSerializers::SerializableResource.new(@room, include: [messages: :user])
  end
end
