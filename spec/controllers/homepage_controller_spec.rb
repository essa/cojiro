require 'spec_helper'

describe HomepageController do

  describe "GET index" do
    before { get :index }

    it "should return success" do
      response.should be_success
    end

    it "should render the index template" do
      response.should render_template("index")
    end
    
  end

end
