require 'vcr'

module MockModels
  ["cothread", "user", "authorization"].each do |model_name|
  eval <<-END_RUBY
    def mock_#{model_name}(stubs={})
    (@mock_#{model_name} ||= mock_model(#{model_name.capitalize}).as_null_object).tap do |m|
      m.stub(stubs) unless stubs.empty?
    end
  end
  END_RUBY
  end
end

module Helpers

  def twitter_sign_in
    visit '/auth/twitter'
  end

  def use_vcr_cassette(name)
    around(:each) do |example|
      VCR.use_cassette(name) { example.run }
    end
  end

end
