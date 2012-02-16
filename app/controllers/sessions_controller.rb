class SessionsController < ApplicationController

  def destroy
    reset_session

    redirect_to homepage_path
  end

  def callback
    auth = auth_hash
    unless @auth = Authorization.find_from_hash(auth)
      # Create a new user or add an auth to existing user, depending on
      # whether there is already a user signed in.
      @auth = Authorization.create_from_hash!(auth, current_user)
    end

    session[:user] = @auth.user.name
    redirect_to '/'
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end

end
