require 'spec_helper'

describe CothreadsController do
  include MockModels

  context "with anonymous user" do

    before { controller.stub(:logged_in?) { false } }

#    it "should redirect new, create and destroy requests to login page" do
      it "should redirect new and create requests to login page" do
      requests = 
        [
          proc {  get :new },
          proc {  post :create, :entry => {'these' => 'params'} },
#          proc {  delete :destroy, :id => "37" },
      ]

      requests.each do |r|
        r.call
        response.should redirect_to(homepage_path)
      end
    end

    describe "GET show" do

      before do
        cothread = mock_cothread
        Cothread.should_receive(:find).with("37").and_return { @cothread }
      end

      before(:each) { get :show, :id => "37" }

      it "assigns the requested cothread as @cothread" do
        assigns(:cothread).should be(@cothread)
      end

      it "renders the show view" do
        response.should render_template("show")
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
          Cothread.stub(:new).with( { 'these' => 'params', 'user_id' => @mock_user.id } ) { cothread }
        end

        before(:each) { post :create, :cothread => { 'these' => 'params' } }

        it "assigns newly created cothread as @cothread" do
          assigns(:cothread).should be(@mock_cothread)
        end

        it "redirects to the cothread" do
          response.should redirect_to(@mock_cothread)
        end

        it "displays a success message" do
          flash[:success].should_not be_nil
        end

      end

      context "with invalid params" do
      end

    end
  end
end
