class LinksController < ApplicationController
  before_filter :login_required, :except => [:index, :show]
  before_filter :find_link, :except => [:index]
  respond_to :json

  def index
    @links = Link.all
    respond_with(@links)
  end

  def show
    raise ActiveRecord::RecordNotFound unless @link
    respond_with(@link)
  end

  #new

  #create

  def update
    if @link
      @link.update_attributes(params[:link])
    else
      @link = Link.new(params[:link])
      @link.user_id = current_user.id
      @link.save
    end
    respond_with(@link) do |format|
      format.json { render :json => @link.to_json, :status => :accepted }
    end
  end

  private

  def find_link
    @link = Link.by_url(params[:id]).first
  end
end
