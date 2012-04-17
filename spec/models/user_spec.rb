require 'spec_helper'

describe User do

  describe ".new_from_hash" do

    before do
      hash = { 
        "provider"=>"twitter", 
        "uid"=>"4138021", 
        "info"=> { "name" => "Cojiro Sasaki", 
          "nickname" => "csasaki",
          "description" => "I like dicing blue chickens.",
          "location" => "Fukui" }
      }
      @cothread = User.new_from_hash(hash)
    end

    subject { @cothread }

    its(:name) { should == "csasaki" }
    its(:fullname) { should == "Cojiro Sasaki" }
    its(:location) { should == "Fukui" }
    its(:profile) { should == "I like dicing blue chickens." }

  end

end
