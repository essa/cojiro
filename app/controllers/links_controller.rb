class LinksController < ApplicationController
  before_filter :login_required, :except => [:index, :show]
  before_filter :initialize_link, :except => [:index, :show]
  respond_to :json

  def index
    @links = Link.all
    respond_with(@links)
  end

  def show
    @link = Link.find_by_url(params[:id])
    raise ActiveRecord::RecordNotFound unless @link
    respond_with(@link)
  end

  #new

  #create

  def update
    @link.user_id ||= current_user.id
    @link.save
    respond_with(@link) do |format|
      format.json do
        if @link.valid?
          render :json => @link.to_json
        else
          render :json => @link.errors.messages, :status => 422
        end
      end
    end
  end

  private

  def initialize_link
    @link = Link.initialize_by_url(params[:id], params[:link] || {})
  end
end
