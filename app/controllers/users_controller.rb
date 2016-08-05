class UsersController < ApplicationController

  before_action :authenticate_user!

  def index
    @users = User.searchable
                 .where.not(id: current_user.id)
                 .where('first_name ~* ? or last_name ~* ?', params[:search], params[:search])
  end

  def show
    @user = User.find(params[:id])
  end

end
