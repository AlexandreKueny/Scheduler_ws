class SessionsController < Devise::SessionsController

  def create
    cookies[:current_user] = current_user.id
    super
  end

  def destroy
    cookies.delete :current_user
    super
  end

end
