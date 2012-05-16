class HomepageController < ApplicationController
  before_filter :find_cothreads, :only => [:index]

  def index
  end

  private

  def find_cothreads
    @cothreads = Cothread.order("created_at DESC").all
  end
end
