require 'spec_helper'

describe LinksController do
  let(:user) { FactoryGirl.create(:user) }

  context 'JSON' do
    context 'with anonymous user' do
      before { controller.stub(:logged_in?) { false } }
    end

    describe 'GET index' do
      it 'assigns links to @links' do
        link = FactoryGirl.create(:link)
        get :index, :format => :json
        assigns(:links).should eq( [ link ] )
      end
    end

    describe 'GET show' do
      it 'assigns the requested link as @link' do
        link = FactoryGirl.create(:link)
        get :show, :id => link.id, :format => :json
        assigns(:link).should eq(link)
      end
    end
  end
end
