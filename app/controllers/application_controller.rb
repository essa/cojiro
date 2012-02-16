class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :initialize_user, :set_locale

  helper_method :logged_in?

  def set_locale
    I18n.locale = params[:locale]
  end

  def url_options
    { :locale => I18n.locale }.merge(super)
  end

  protected

  def logged_in?
    current_user.is_a?(User)
  end

  # get current user
  def current_user
    @current_user
  end

  # setup user info on each page
  def initialize_user
    User.current_user = @current_user = User.find_by_name(session[:user]) if session[:user]
  end

end
