class CommentsController < ApplicationController
  before_filter :find_cothread
  respond_to :json, :only => [ :create ]

  def create
    @comment = Comment.new(params[:comment])
    @comment.user_id = current_user.id
    @comment.cothread = @cothread
    @comment.save
    respond_with(@cothread, @comment)
  end

  private

  def find_cothread
    @cothread = Cothread.find(params[:cothread_id])
  end
end
