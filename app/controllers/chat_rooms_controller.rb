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
  end

  # GET /chat_rooms/new
  def new
    existing_chat_room = nil
    users = JSON.parse params[:users]
    ChatRoom.find_each do |chat|
      existing_chat_room = chat if ([current_user.id].concat(users) - chat.users.ids).empty? and chat.users.size == users.size + 1
    end
    if existing_chat_room
      @chat_room = existing_chat_room
      respond_to do |format|
        format.html { redirect_to user_chat_room_url(current_user, @chat_room) }
        format.json { render json: {href: user_chat_room_url(current_user, @chat_room)} }
      end
    else
      create
    end
  end

  # GET /chat_rooms/1/edit
  def edit
  end

  # POST /chat_rooms
  # POST /chat_rooms.json
  def create
    users = JSON.parse params[:users]
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

  # PATCH/PUT /chat_rooms/1
  # PATCH/PUT /chat_rooms/1.json
  def update

    if params[:removed] and params[:added]
      add= JSON.parse params[:added]
      remove = JSON.parse params[:removed]

      force_del = []
      force_add = []
      commons = add & remove
      commons.each do |common|
        force_del << common if remove.count(common) > add.count(common)
        force_add << common if remove.count(common) < add.count(common)
      end
    end

    if params[:name]
      @chat_room.update!(name: params[:name])
    end
    if remove
      remove.uniq.each do |removed|
        @chat_room.users.delete User.find removed unless commons.include? removed and not force_del.include? removed
      end
    end
    if add
      add.uniq.each do |added|
        @chat_room.users << User.find(added) unless commons.include? added and not force_add.include? added
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
