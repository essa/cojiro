require 'spec_helper'

describe CothreadsController do
  include MockModels
  let(:user) { FactoryGirl.create(:user) }
  let(:translated_attributes) do
    { "title" => { "en" => "a title in English", "ja" => "a title in Japanese" },
      "summary" => { "en" => "a summary in English", "ja" => "a summary in Japanese" } }
  end

  context "HTML" do
    before do
      controller.stub(:logged_in?) { true }
      controller.stub(:current_user) { user }
    end

    describe "GET new" do

      it "renders the new view" do
        get :new, :format => :html
        response.should render_template("new")
      end

    end

    describe "GET show" do

      it "finds the thread" do
        Cothread.should_receive(:find).with("37").and_return(mock_cothread)
        get :show, :id => "37", :format => :html
      end

      it "renders the show view if thread exists" do
        Cothread.stub(:find).with("37") { mock_cothread }
        get :show, :id => "37", :format => :html
        response.should render_template("show")
      end

      it "displays an error if thread does not exist" do
        lambda {
          get :show, :id => "not-found", :format => :html
        }.should raise_error(ActiveRecord::RecordNotFound)
      end

    end

  end

  context "JSON" do

    context "with anonymous user" do
      before { controller.stub(:logged_in?) { false } }

      describe "GET index" do

        it "assigns cothreads to @cothreads" do
          cothread = FactoryGirl.create(:cothread)
          get :index, :format => :json
          assigns(:cothreads).should eq( [ cothread ] )
        end

      end

      describe "GET show" do

        it "assigns the requested cothread as @cothread" do
          cothread = FactoryGirl.create(:cothread)
          get :show, :id => cothread.id, :format => :json
          assigns(:cothread).should eq(cothread)
        end

      end

    end

    context "with logged-in user" do
      before do
        controller.stub(:logged_in?) { true }
        controller.stub(:current_user) { user }
      end

      describe "POST create" do

        context "with valid params" do
          # on the client-side, 'thread' is used instead of 'cothread'
          it "creates a new thread" do
            expect {
              post :create, thread: FactoryGirl.attributes_for(:cothread, translated_attributes), :format => :json
            }.to change(Cothread, :count).by(1)
          end

          it "returns the new thread" do
            post :create, thread: FactoryGirl.attributes_for(:cothread, translated_attributes), :format => :json
            JSON(response.body).should include(translated_attributes)
          end

        end

      end

      describe "PUT update" do

        before do
          @cothread = FactoryGirl.create(:cothread, title: "a title")
        end

        context "with valid params" do

          it "locates the requested @cothread" do
            put :update,
              id: @cothread.id,
              thread: FactoryGirl.attributes_for(:cothread, translated_attributes),
              format: :json
            assigns(:cothread).should eq(@cothread)
          end

          it "updates the thread" do
            put :update,
              id: @cothread.id,
              thread: FactoryGirl.attributes_for(:cothread, { "summary" => nil, "title" => { "en" => "a new title" }}),
              format: :json
            assigns(:cothread).title.should eq("a new title")
          end

          it "returns the new thread" do
            attr = FactoryGirl.attributes_for(:cothread, { "title" => { "en" => "a new title" }})
            attr.delete(:summary)
            put :update, id: @cothread.id, thread: attr, format: :json
            JSON(response.body).should include(attr.stringify_keys)
          end
        end
      end

    end

  end

end
