require 'spec_helper'

describe CothreadsController do

  ["cothread", "user"].each do |model_name|
  eval <<-END_RUBY
    def mock_#{model_name}(stubs={})
    (@mock_#{model_name} ||= mock_model(#{model_name.capitalize}).as_null_object).tap do |m|
      m.stub(stubs) unless stubs.empty?
    end
  end
  END_RUBY
  end

  describe "GET show" do
    before do
      cothread = mock_cothread
      Cothread.should_receive(:find).with("37").and_return { @cothread }
    end

    it "assigns the requested cothread as @cothread" do
      get :show, :id => "37"
      assigns(:cothread).should be(@cothread)
    end

    it "renders the show view" do
      get :show, :id => "37"
      response.should render_template("show")
    end

  end

  context "with logged-in user" do

    before do
#      controller.stub(:logged_in?) { true }
      user = mock_user
      controller.stub(:current_user) { user }
    end

    describe "GET new" do

      before do
        cothread = mock_cothread
        Cothread.should_receive(:new).and_return { cothread }
      end

      it "assigns newly created cothread as @cothread" do
        get :new
        assigns(:cothread).should be(@mock_cothread)
      end

      it "renders the new view" do
        get :new
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

        it "assigns newly created cothread as @cothread" do
          post :create, :cothread => { 'these' => 'params' }
          assigns(:cothread).should be(@mock_cothread)
        end

        it "redirects to the cothread"
        it "displays a success message"
      end

      context "with invalid params" do
      end

    end
  end
end
