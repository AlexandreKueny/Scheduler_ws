class MessagesController < ApplicationController
  before_action :set_message, only: [:show, :edit, :update, :destroy]

  # GET /messages
  # GET /messages.json
  def index
    @messages = Message.all
  end

  # GET /messages/1
  # GET /messages/1.json
  def show
  end

  # GET /messages/new
  def new
    @message = Message.new
  end

  # GET /messages/1/edit
  def edit
  end

  # POST /messages
  # POST /messages.json
  def create
    message = ChatRoom.find(params[:chat_room_id]).messages.build(content: params[:content])
    message.user = current_user
    ChatRoom.find(params[:chat_room_id]).chat_rooms_users.each do |chat_room_user|
      chat_room_user.update(deleted: false)
    end
    ChatRoom.find(params[:chat_room_id]).chat_rooms_users.each do |chat_room_user|
      if current_user != chat_room_user.user
        chat_room_user.update(unread: chat_room_user.unread.to_i + 1)
      end
    end
    if session[:user_ids]
      if ChatRoom.find(params[:chat_room_id]).users.count < session[:user_ids].count
        session[:user_ids].each do |user_id|
          ChatRoom.find(params[:chat_room_id]).users << User.find(user_id)
        end
        session[:user_ids] = nil
      end
    end
    message.save
    unread = 0
    chat_room_unread = 0
    ChatRoom.find(params[:chat_room_id]).chat_rooms_users.each do |chat_room_user|
      unread += chat_room_user.unread.to_i
      chat_room_unread = chat_room_user.unread.to_i if chat_room_user.chat_room == ChatRoom.find(params[:chat_room_id])
    end
    ActionCable.server.broadcast 'messages',
                                 message: message.content,
                                 user: message.user.first_name,
                                 unread: unread,
                                 chat_room_id: params[:chat_room_id],
                                 chat_room_unread: chat_room_unread
    head :ok
  end

  # PATCH/PUT /messages/1
  # PATCH/PUT /messages/1.json
  def update
    respond_to do |format|
      if @message.update(message_params)
        format.html { redirect_to @message, notice: 'Message was successfully updated.' }
        format.json { render :show, status: :ok, location: @message }
      else
        format.html { render :edit }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
    @message.destroy
    respond_to do |format|
      format.html { redirect_to messages_url, notice: 'Message was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_message
    @message = Message.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def message_params
    params.require(:message).permit(:content)
  end
end
