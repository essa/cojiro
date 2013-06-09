class LinksController < ApplicationController
  before_filter :login_required, :except => [:index, :show]
  before_filter :find_link, :except => [:index, :create]
  respond_to :json, :only => [ :index, :show, :create ]

  def index
    @links = Link.all
    respond_with(@links)
  end

  def show
    respond_with(@link)
  end

  #new

  def create
    @link = Link.new(params[:link])
    @link.user_id = current_user.id
    @link.save
    respond_with(@link)
  end

  private

  def find_link
    @link = Link.find(params[:id])
  end
end
