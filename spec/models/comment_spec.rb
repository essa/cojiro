require 'spec_helper'
require 'shoulda-matchers'

describe Comment do
  describe 'associations' do
    it { should belong_to(:link) }
    it { should belong_to(:cothread) }
  end

  describe '#to_json' do
    before do
      @comment = FactoryGirl.build(:comment,
                                   link: FactoryGirl.create(:link))
      @comment_json = @comment.to_json
    end

    it 'includes link' do
      JSON(@comment_json)['link'].should be
      JSON(@comment_json)['link']['url'].should be
    end
  end
end
