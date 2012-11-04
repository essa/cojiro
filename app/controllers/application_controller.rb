class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :initialize_user, :set_locale, :set_requirejs_config

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

  def login_required
    redirect_to homepage_path unless logged_in?
  end

  # get current user
  def current_user
    @current_user
  end

  # setup user info on each page
  def initialize_user
    User.current_user = @current_user = User.find_by_name(session[:user]) if session[:user]
  end

  def set_requirejs_config
    config = {
      globals: {
        :current_user => @current_user
      },
      :'i18n-init' => {
        :locale => I18n.locale,
        :default_locale => I18n.default_locale
      }
    }
    Requirejs::Rails::Engine.config.requirejs.run_config.merge!({ :config => config })
  end

  def available_locales
    I18n.available_locales
  end
end
