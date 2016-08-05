class Ability
  include CanCan::Ability

  def initialize(user)

    can :manage, ChatRoom do |chat_room|
      chat_room.users.include? user
    end

    can :manage, ChatRoomsUser, user_id: user.id

  end
end
