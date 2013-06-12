require 'spec_helper'
require 'timecop'
require 'shoulda-matchers'

describe Comment do
  describe 'associations' do
    it { should belong_to(:link) }
    it { should belong_to(:cothread) }
  end

  describe '#to_json' do
    before do
      Timecop.freeze(Time.utc(2012,6,11,12,20)) do
        @comment = FactoryGirl.build(:comment,
                                     link: FactoryGirl.create(:link))
        @comment.save
      end
      @comment_json = @comment.to_json
    end

    it 'has an id' do
      JSON(@comment_json)['id'].should be
    end

    it 'has a text' do
      JSON(@comment_json)['text'].should be
    end

    it "has created_at and updated_at timestamps" do
      JSON(@comment_json)["created_at"].should == "2012-06-11T12:20:00Z"
      JSON(@comment_json)["updated_at"].should == "2012-06-11T12:20:00Z"
    end

    it 'does not include any other attributes' do
      JSON(@comment_json).keys.delete_if { |k|
        [ 'id',
          'text',
          'created_at',
          'updated_at',
          'link'
        ].include?(k)
      }.should be_empty
    end

    it 'includes link' do
      JSON(@comment_json)['link'].should be
      JSON(@comment_json)['link']['url'].should be
    end
  end
end
