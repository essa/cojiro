require 'spec_helper'

describe CommentsController do
  let(:comment) { FactoryGirl.create(:comment) }
  let(:cothread) { FactoryGirl.create(:cothread) }

  context 'JSON' do
    context 'with logged-in user' do
      let(:user) { FactoryGirl.create(:user) }
      before do
        controller.stub(:logged_in?) { true }
        controller.stub(:current_user) { user }
      end

      describe 'POST create' do
        context 'with valid params' do
          context 'with no nested link attributes' do
            it 'creates a new comment' do
              expect {
                post :create,
                  cothread_id: cothread.id,
                  comment: FactoryGirl.attributes_for(:comment).except(:cothread),
                  format: :json
              }.to change(Comment, :count).by(1)
            end
          end

          context 'with nested link' do
            before do
              @comment_attributes = FactoryGirl.attributes_for(:comment).except(:cothread)
              @comment_attributes[:link_attributes] = FactoryGirl.attributes_for(:link).except(:user)
            end

            it 'creates a new comment' do
              expect {
                post :create,
                  cothread_id: cothread.id,
                  comment: @comment_attributes,
                  format: :json
              }.to change(Comment, :count).by(1)
            end

            it 'creates a new link' do
              expect {
                post :create,
                  cothread_id: cothread.id,
                  comment: @comment_attributes,
                  format: :json
              }.to change(Link, :count).by(1)
            end
          end
        end
      end
    end
  end
end
