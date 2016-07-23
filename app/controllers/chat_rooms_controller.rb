class ChatRoomsController < ApplicationController
  before_action :set_chat_room, only: [:show, :edit, :update, :destroy]

  # GET /chat_rooms
  # GET /chat_rooms.json
  def index
    @chat_rooms_users = current_user.chat_rooms_users.current
  end

  # GET /chat_rooms/1
  # GET /chat_rooms/1.json
  def show
    @chat_room.chat_rooms_users.where(user_id: current_user.id).take.update(unread: 0)
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
    ChatRoom.find_each do |chat|
      existing_chat_room = chat if chat.users.include? current_user and chat.users.include? User.find(params[:user_id]) and chat.users.size == 2
    end
    if existing_chat_room
      @chat_room = existing_chat_room
    else
      chat_room = ChatRoom.create
      @chat_room = chat_room
      session[:user_ids] = [params[:user_id], current_user.id]
    end
    ChatRoomCleanupJob.set(wait: 1.minute).perform_later(@chat_room)
    @response = {url: user_chat_room_path(current_user, @chat_room), notice: 'Chat room was successfully created.'}
    render :show
  end

  # PATCH/PUT /chat_rooms/1
  # PATCH/PUT /chat_rooms/1.json
  def update
    @chat_room.update!(name: params[:name])
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
