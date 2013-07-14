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
        context 'url exact match' do
          it 'assigns the requested link as @link' do
            link = FactoryGirl.create(:link)
            get :show, :id => link.url, :format => :json
            assigns(:link).should eq(link)
          end
        end

        context 'url heuristic match' do
          it 'assigns the requested link as @link' do
            link = FactoryGirl.create(:link, :url => 'http://www.foo.com/')
            get :show, :id => 'www.foo.com', :format => :json
            assigns(:link).should eq(link)
          end
        end

        context 'url no match' do
          it 'returns 404 when not found' do
            get :show, :id => 'www.bar.com', :format => :json
            response.response_code.should == 404
          end
        end
      end
    end

    context 'with logged-in user' do
      before do
        controller.stub(:logged_in?) { true }
        controller.stub(:current_user) { user }
      end

      describe 'PUT update' do
        context 'with valid params' do
          let(:url) { 'www.foo.com' }
          let(:normalized_url) { 'http://www.foo.com/' }
          let(:attrs) { FactoryGirl.attributes_for(:link, :url => url) }

          context 'if link with url does not yet exist' do
            it 'creates a new link' do
              expect {
                post :update, id: url, link: attrs, format: :json
              }.to change(Link, :count).by(1)
            end

            it 'returns the new link with normalized url' do
              post :update, id: url, link: attrs, :format => :json
              JSON(response.body).should include('url' => normalized_url)
            end
          end

          context 'if link with url already exists' do
            let!(:link) { FactoryGirl.create(:link, url: normalized_url) }

            it 'locates the requested @link' do
              put :update, id: url, link: attrs, format: :json
              assigns(:link).should eq(link)
            end

            it 'returns the new link with updated attributes and normalized url' do
              attrs.merge!(
                title: { en: 'title' },
                summary: { en:'summary' },
                source_locale: 'en')
              put :update, id: link.url, link: attrs, format: :json
              JSON(response.body).should include(
                'title' => { 'en' => 'title' },
                'summary'  => { 'en' => 'summary' },
                'source_locale' => 'en',
                'url' => normalized_url
              )
            end
          end
        end

        context 'with invalid params' do
          let(:invalid_attrs) { FactoryGirl.attributes_for(:link, :invalid) }

          it 'does not create the link' do
            expect {
              post :update, id: invalid_attrs[:url], link: invalid_attrs, format: :json
            }.not_to change(Link, :count)
          end

          it 'returns 422 unprocessable entity' do
            post :update, id: invalid_attrs[:url], link: invalid_attrs, format: :json
            response.response_code.should == 422
          end

          it 'returns error messages' do
            invalid_link = Link.new(invalid_attrs)
            invalid_link.valid?
            messages = invalid_link.errors.messages.except(:user).stringify_keys
            post :update, id: invalid_attrs[:url], link: invalid_attrs, format: :json
            JSON(response.body).should include(messages)
          end
        end
      end
    end
  end
end
