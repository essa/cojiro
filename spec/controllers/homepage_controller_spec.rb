require 'spec_helper'

describe HomepageController do

  describe "GET index" do

    before(:each) { get :index }

    it "returns success" do
      response.should be_success
    end

    it "renders the index template" do
      response.should render_template("index")
    end
    
  end

end
