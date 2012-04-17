require 'spec_helper'

describe CothreadsController do
  include MockModels

  context "with anonymous user" do

    before { controller.stub(:logged_in?) { false } }

    it "redirects new, create and destroy requests to login page" do
      requests = 
        [
          proc {  get :new },
          proc {  post :create, :entry => {'these' => 'params'} },
          proc {  delete :destroy, :id => "37" },
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
          Cothread.stub(:new).with( { 'these' => 'params' } ) { cothread }
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

        before do
          cothread = mock_cothread
          cothread.should_receive(:save).and_return { false }
          Cothread.stub(:new).with( { 'these' => 'params' } ) { cothread }
        end

        before(:each) { post :create, :cothread => { 'these' => 'params' } }

        it "assigns newly created cothread as @cothread" do
          assigns(:cothread).should be(@mock_cothread)
        end

        it "re-renders the new cothread page" do
          response.should render_template("new")
        end

        it "displays an error message" do
          flash[:error].should == "There were errors in the information entered."
        end
      end

    end

    describe "DELETE destroy" do

      before do
        cothread = mock_cothread(:title => "Co-working spaces in Tokyo")
        Cothread.should_receive(:find).and_return(cothread)
      end

      context "with valid params" do

        before do
          @mock_cothread.should_receive(:destroy).and_return(true)
          delete :destroy, :id => 37
        end

        it "redirects to the homepage" do
          response.should redirect_to homepage_path
        end

        it "returns a success message" do
          flash[:success].should == "Cothread \"Co-working spaces in Tokyo\" deleted."
        end

      end

      context "with invalid params" do

        before do
          @mock_cothread.should_receive(:destroy).and_return(false)
          delete :destroy, :id => 37
        end

        it "redirects to the homepage" do
          response.should redirect_to homepage_path
        end

        it "returns an error message"

      end

    end

  end
end
