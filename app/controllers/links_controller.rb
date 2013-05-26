class LinksController < ApplicationController
  before_filter :find_link, :except => [:index]
  respond_to :json, :only => [ :index, :show ]

  def index
    @links = Link.all
    respond_with(@links)
  end

  def show
    respond_with(@link)
  end

  private

  def find_link
    @link = Link.find(params[:id])
  end
end
