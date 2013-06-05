require 'spec_helper'

describe LinksController do
  let(:user) { FactoryGirl.create(:user) }

  context 'JSON' do
    context 'with anonymous user' do
      before { controller.stub(:logged_in?) { false } }

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

    context 'with logged-in user' do
      before do
        controller.stub(:logged_in?) { true }
        controller.stub(:current_user) { user }
      end

      describe 'POST create' do

        describe 'step 1: url' do
          it 'creates a new link' do
            expect {
              post :create, thread: FactoryGirl.attributes_for(:link)
            }.to change(Link, :count).by(1)
          end

          it 'returns the new link' do
            attr = FactoryGirl.attributes_for(:link)
            post :create, link: attr, :format => :json
            JSON(response.body).should include(attr.stringify_keys)
          end
        end
      end
    end
  end
end
