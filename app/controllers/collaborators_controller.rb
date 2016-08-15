class CollaboratorsController < ApplicationController

  before_action :authenticate_user!

  def index
    #@collaborators = []
    if params[:search]
      @collaborators = current_user.collaborators.joins(:collaborators_links).merge(CollaboratorsLink.accepted).distinct.where('first_name ~* ? or last_name ~* ?', params[:search], params[:search])
    else
      @collaborators = current_user.collaborators.joins(:collaborators_links).merge(CollaboratorsLink.accepted).distinct
      @collaborators_requests = CollaboratorsLink.unaccepted.requested_to(current_user)
    end
  end

  def new
    current_user.collaborators << User.find(params[:user_id])
    head :ok
  end

  def respond
    if params[:decision] == 'accept'
      CollaboratorsLink.find(params[:collaborators_link_id]).update(accepted: true)
      CollaboratorsLink.create(user_id: current_user.id, collaborator_id: User.find(CollaboratorsLink.find(params[:collaborators_link_id]).user_id).id, accepted: true)
    else
      CollaboratorsLink.find(params[:collaborators_link_id]).destroy
    end
  end

  def remove
    current_user.collaborators.delete(User.find(params[:user_id]))
    User.find(params[:user_id]).collaborators.delete(current_user)
  end

end
