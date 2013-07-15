class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :initialize_user, :set_locale, :set_requirejs_config

  helper_method :logged_in?

  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

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
        :currentUser => @current_user
      },
      :'adapters/i18n-adapter' => {
        :locale => I18n.locale,
        :availableLocales => I18n.available_locales
      }
    }
    opts = { :config => config }
    opts.merge!({ :urlArgs => "bust=#{Time.now.to_i}" }) if Rails.env == "development"
    Requirejs::Rails::Engine.config.requirejs.run_config.merge!(opts)
  end

  def available_locales
    I18n.available_locales
  end

  private

  def record_not_found(error)
    respond_to do |format|
      format.json { render :json => { :error => error.message }, :status => :not_found }
      format.html { render :file => 'public/404', :status => :not_found, :layout => false, :formats => [:html] }
    end
  end
end
