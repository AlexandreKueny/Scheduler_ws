class ChatRoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_chat_room, only: [:show, :edit, :update, :destroy]

  # GET /chat_rooms
  # GET /chat_rooms.json
  def index
    @unread_chat_rooms_users = User.find(params[:user_id]).chat_rooms_users.current.unread(true).joins(:chat_room).merge(ChatRoom.active).order('chat_rooms.updated_at desc')
    @read_chat_rooms_users = User.find(params[:user_id]).chat_rooms_users.current.unread(false).joins(:chat_room).merge(ChatRoom.active).order('chat_rooms.updated_at desc')
    @unread_chat_rooms_users.each do |chat_room_user|
      authorize! :index, chat_room_user
    end
    @read_chat_rooms_users.each do |chat_room_user|
      authorize! :index, chat_room_user
    end
  end

  # GET /chat_rooms/1
  # GET /chat_rooms/1.json
  def show
    authorize! :show, @chat_room
    if chat_rooms_user = @chat_room.chat_rooms_users.find_by(user_id: params[:user_id])
      chat_rooms_user.update(unread: 0)
    end
    @message = Message.new
    @date = @chat_room.created_at
    @last_date = @date.to_date
  end

  # GET /chat_rooms/new
  def new
    @chat_room = ChatRoom.new
  end

  # GET /chat_rooms/1/edit
  def edit
  end

  # POST /chat_rooms
  # POST /chat_rooms.json
  def create
    existing_chat_room = nil
    users = params[:users]
    current_user.chat_rooms.find_each do |chat|
      existing_chat_room = chat if ([current_user.id].concat(users) - chat.users.ids).empty? and chat.users.size == users.size + 1
    end
    if existing_chat_room
      @chat_room = existing_chat_room
      respond_to do |format|
        format.html { redirect_to user_chat_room_url(current_user, @chat_room) }
        format.json { render json: {href: user_chat_room_url(current_user, @chat_room)} }
      end
    else
      chat_room = ChatRoom.new
      users.each do |user|
        chat_room.users << User.find(user)
      end
      chat_room.users << current_user
      chat_room.save
      @chat_room = chat_room
      ChatRoomCleanupJob.set(wait: 1.minute).perform_later(@chat_room)
      respond_to do |format|
        format.html { redirect_to user_chat_room_url(current_user, @chat_room) }
        format.json { render json: {href: user_chat_room_url(current_user, @chat_room)} }
      end
    end
  end

  # PATCH/PUT /chat_rooms/1
  # PATCH/PUT /chat_rooms/1.json
  def update

    if params[:name]
      @chat_room.update!(name: params[:name])
    elsif params[:users]
      users = params[:users]
      users << current_user.id
      chat_room_users = @chat_room.users.ids
      add = users - chat_room_users
      remove = chat_room_users - users
      add.each do |user_id|
        @chat_room.users << User.find(user_id)
      end
      remove.each do |user_id|
        @chat_room.users.delete User.find(user_id)
      end
    end
    head :ok
  end

  # DELETE /chat_rooms/1
  # DELETE /chat_rooms/1.json
  def destroy
    @chat_room.destroy
    respond_to do |format|
      format.html { redirect_to chat_rooms_url, notice: 'Chat room was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_chat_room
    @chat_room = ChatRoom.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def chat_room_params
    params.require(:chat_room).permit(:name)
  end

end
