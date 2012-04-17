class CothreadsController < ApplicationController
  before_filter :login_required, :except => [:show]
  before_filter :find_cothread, :except => [:new, :create]

  def show
  end

  def new
    @cothread = Cothread.new
  end

  def create
    @cothread = Cothread.new(params[:cothread])
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
