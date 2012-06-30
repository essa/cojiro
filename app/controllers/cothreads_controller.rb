class CothreadsController < ApplicationController
  before_filter :login_required, :except => [:index, :show]
  before_filter :find_cothread, :except => [:index, :new, :create]
  respond_to :html, :json

  def index
    @cothreads = Cothread.recent.all
    respond_with(@cothreads)
  end

  def show
    respond_with(@cothread)
  end

  def new
    @cothread = Cothread.new
  end

  def create
    respond_to do |format|
      format.html { @cothread = Cothread.new(params[:cothread]) }
      format.json { @cothread = Cothread.new(params[:thread]) }
    end
    @cothread.user_id = current_user.id
    if @cothread.save
      flash[:success] = "New thread successfully created."
      redirect_to @cothread
    else
      flash.now[:error] = "There were errors in the information entered."
      render :new
    end
  end

  def destroy
    title = @cothread.title
    if @cothread.destroy
      flash[:success] = "Thread \"#{title}\" deleted."
    else
      flash[:error] = "Thread \"#{title}\" could not be deleted."
    end
    redirect_to homepage_path
  end

  private

  def find_cothread
    @cothread = Cothread.find(params[:id])
  end

end
