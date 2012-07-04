require 'spec_helper'

describe HomepageController do

  def mock_cothread(stubs={})
    (@mock_cothread ||= mock_model(Cothread).as_null_object).tap do |cothread|
      cothread.stub(stubs) unless stubs.empty?
    end
  end

  describe "GET index" do
    before do
      Cothread.stub(:recent) do
        double.tap { |d| d.stub(:all) { [ mock_cothread ] } }
      end
    end

    it "assigns cothreads to @cothreads" do
      get :index
      assigns(:cothreads).should eq( [ @mock_cothread ] )
    end

  end

end
