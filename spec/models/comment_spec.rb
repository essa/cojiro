require 'spec_helper'
require 'shoulda-matchers'

describe Comment do
  describe 'associations' do
    it { should belong_to(:link) }
    it { should belong_to(:cothread) }
  end
end
