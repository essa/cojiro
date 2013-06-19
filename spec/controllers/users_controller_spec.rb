require 'spec_helper'

describe UsersController do

  context 'JSON' do
    describe 'GET show' do
      it 'assigns the requested user as @user' do
        user = FactoryGirl.create(:user)
        get :show, :id => user.to_param, :format => :json
        assigns(:user).should eq(user)
      end
    end
  end
end
