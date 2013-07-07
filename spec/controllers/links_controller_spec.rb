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

      describe 'POST create' do
        it 'redirects to homepage' do
          post :create
          response.should redirect_to(homepage_path)
        end
      end
    end

    context 'with logged-in user' do
      before do
        controller.stub(:logged_in?) { true }
        controller.stub(:current_user) { user }
      end

      describe 'POST create' do
        context 'with valid params' do

          it 'does not crash on blank params' do
            expect {
              post :create
            }.not_to raise_error
          end

          context 'url not yet registered' do
            it 'creates a new link' do
              expect {
                post :create, link: FactoryGirl.attributes_for(:link), format: :json
              }.to change(Link, :count).by(1)
            end

            it 'returns the new link' do
              attrs = FactoryGirl.attributes_for(:link)
              post :create, link: attrs, :format => :json
              JSON(response.body).should include(attrs.stringify_keys)
            end
          end

          context 'url already registered' do
            let!(:link) { FactoryGirl.create(:link, url: 'http://www.foo.com') }

            it 'does not create new link' do
              expect {
                post :create, link: { url: 'http://www.foo.com' }, format: :json
              }.not_to change(Link, :count)
            end

            it 'assigns existing link to @link' do
              post :create, link: { url: 'http://www.foo.com' }, format: :json
              assigns(:link).should eq(link)
            end

            it 'returns existing link' do
              post :create, link: { url: 'http://www.foo.com' }, format: :json
              response.body.should == link.to_json
            end
          end
        end
      end

      describe 'PUT update' do
        let(:link) { FactoryGirl.create(:link) }

        context 'with valid params' do
          it 'locates the requested @link' do
            put :update, id: link.id, link: FactoryGirl.attributes_for(:link), format: :json
            assigns(:link).should eq(link)
          end

          it 'returns the new link' do
            attr = FactoryGirl.attributes_for(:link, title: { "en" => "title" }, summary: { "en" => "summary" })
            put :update, id: link.id, link: attr, format: :json
            JSON(response.body).should include(attr.stringify_keys)
          end
        end
      end
    end
  end
end
