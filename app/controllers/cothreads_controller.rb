class CothreadsController < ApplicationController
  before_filter :find_cothread, :except => [:new, :create]

  def show
  end

  def new
    @cothread = Cothread.new
  end

  def create
    @cothread = Cothread.new(params[:cothread].merge(:user_id => current_user.id))
    @cothread.save
    redirect_to @cothread
  end

  private

  def find_cothread
    @cothread = Cothread.find(params[:id])
  end

end
