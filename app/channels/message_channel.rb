class MessageChannel < ApplicationCable::Channel
  # 接続されたとき
  def subscribed
    room = MessageRoom.find(params[:message_room_id])
    if room.users.any? { |user| user.id == params[:user_id].to_i && user == current_user }
      stream_from room.name 
    else
      reject
    end
  end

  # 切断されたとき
  def unsubscribed; end

  def speak(data)
    Message.create!(text: data['text'], user_id: data['user_id'], message_room_id: data['message_room_id'])
  rescue => e
    Rails.logger.error(e.inspect)
    Rails.logger.error(e.backtrace)
  end
end
