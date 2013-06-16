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
    subject { JSON(@comment.to_json) }
    its(['id']) { should be }
    its(['text']) { should be }
    its(['created_at']) { should == "2012-06-11T12:20:00Z" }
    its(['updated_at']) { should == "2012-06-11T12:20:00Z" }
    its(['link']) { should be }
    its(['link']) { should have_key('url') }

    it 'does not include any other attributes' do
      subject.keys.delete_if { |k|
        [ 'id', 'text', 'created_at', 'updated_at', 'link' ].include?(k)
      }.should be_empty
    end
  end
end
