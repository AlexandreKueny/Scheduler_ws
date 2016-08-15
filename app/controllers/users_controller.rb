class UsersController < ApplicationController

  before_action :authenticate_user!

  def index
    searchables = User.searchable
                 .where.not(id: current_user.id)
                 .where('first_name ~* ? or last_name ~* ?', params[:search], params[:search])

    collaborators = current_user.collaborators.joins(:collaborators_links).merge(CollaboratorsLink.accepted)
                    .where('first_name ~* ? or last_name ~* ?', params[:search], params[:search])

    @users = []
    searchables.each do |user|
      @users << user
    end
    collaborators.each do |user|
      @users << user
    end
    @users.uniq!

end

  def show
    @user = User.find(params[:id])
    @messages_accepted = messages_accepted?
    respond_to do |format|
      format.html
      format.json
      format.js
    end
  end

  private

  def messages_accepted?
    status = User.find(params[:id]).accept_messages_from
    case status
      when 1
        true
      when 3
        false
      when 2
        (User.find(params[:id]).collaborators.include? current_user)? true : false
    end
  end

end
