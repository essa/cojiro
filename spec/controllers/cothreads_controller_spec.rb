require 'spec_helper'

describe CothreadsController do
  include MockModels

  context "with anonymous user" do

    before { controller.stub(:logged_in?) { false } }

    describe "GET index" do
      before do
        Cothread.stub(:recent) do
          double.tap do |d|
            d.stub(:all) { [ mock_cothread ] }
          end
        end
      end

      it "assigns cothreads to @cothreads" do
        begin
          get :index
          # ignore the fact that there's no template (JSON only)
        rescue ActionView::MissingTemplate
        end
        assigns(:cothreads).should eq( [ @mock_cothread ] )
      end

    end

    describe "GET show" do

      context "record found" do
        before do
          Cothread.should_receive(:find).with("37").and_return { mock_cothread }
        end

        before(:each) { get :show, :id => "37" }

        it "assigns the requested cothread as @cothread" do
          assigns(:cothread).should be(@mock_cothread)
        end

        it "renders the show view" do
          response.should render_template("show")
        end

      end

    end

  end

  context "with logged-in user" do

    before do
      controller.stub(:logged_in?) { true }
      user = mock_user
      controller.stub(:current_user) { user }
    end

    describe "GET new" do

      before do
        cothread = mock_cothread
        Cothread.should_receive(:new).and_return { cothread }
      end

      before(:each) { get :new }

      it "assigns newly created cothread as @cothread" do
        assigns(:cothread).should be(@mock_cothread)
      end

      it "renders the new view" do
        response.should render_template("new")
      end

    end

    describe "POST create" do

      context "with valid params" do

        before do
          cothread = mock_cothread
          cothread.should_receive(:save).and_return { true }
          Cothread.stub(:new).with( { 'these' => 'params' } ) { cothread }
        end

        # on the client-side, 'thread' is used instead of 'cothread'
        before(:each) { post :create, :thread => { 'these' => 'params' } }

        it "assigns a newly created cothread as @cothread" do
          assigns(:cothread).should be(@mock_cothread)
        end

      end

    end

  end

end
