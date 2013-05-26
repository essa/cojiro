require 'spec_helper'
require 'shoulda-matchers'

describe Link do
  describe 'associations' do
    it { should have_many(:comments) }
    it { should have_many(:cothreads).through(:comments) }
  end
end
