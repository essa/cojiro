class CothreadsController < ApplicationController
  before_filter :login_required, :except => [:show]
  before_filter :find_cothread, :except => [:new, :create]

  def show
  end

  def new
    @cothread = Cothread.new
  end

  def create
    @cothread = Cothread.new(params[:cothread].merge(:user_id => current_user.id))
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
      flash[:success] = "Cothread \"#{title}\" deleted."
    end
    redirect_to homepage_path
  end

  private

  def find_cothread
    @cothread = Cothread.find(params[:id])
  end

end
