require 'spec_helper'

describe CommentsController do
  let(:comment) { FactoryGirl.create(:comment) }
  let(:cothread) { FactoryGirl.create(:cothread) }

  context 'JSON' do
    context 'with logged-in user' do
      before do
        controller.stub(:logged_in?) { true }
        controller.stub(:current_user) { user }
      end

      describe 'POST create' do

        context 'with valid params' do

          it 'creates a new comment' do
            expect {
              post :create, cothread_id: cothread.id, comment: FactoryGirl.attributes_for(:comment).except(:cothread), format: :json
            }.to change(Comment, :count).by(1)
          end
        end
      end
    end
  end
end
