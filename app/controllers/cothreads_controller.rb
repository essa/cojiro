class CothreadsController < ApplicationController
  before_filter :login_required, :except => [:index, :show]
  before_filter :find_cothread, :except => [:index, :new, :create]
  respond_to :json, :except => :new
  respond_to :html, :only => [ :show, :new ]

  def index
    @cothreads = Cothread.with_translations(available_locales).recent.all
    respond_with(@cothreads)
  end

  def show
    respond_with(@cothread)
  end

  def new
  end

  def create
    @cothread = Cothread.new_from_json(params[:thread])
    @cothread.user_id = current_user.id
    @cothread.save
    respond_with(@cothread)
  end

  def update
    @cothread.set_from_json(params[:thread])
    @cothread.save
    respond_with @cothread do |format|
      format.json { render :json => @cothread.to_json, :status => :accepted }
    end
  end

  private

  def find_cothread
    @cothread = Cothread.find(params[:id])
  end

end
