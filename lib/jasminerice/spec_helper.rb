require "requirejs-rails"

module Jasminerice
  module SpecHelper
    include RequirejsHelper

    def spec_files
      spec_files = []
      env = Rails.application.assets
      env.each_logical_path do |lp|
        spec_files << lp if lp =~ %r{^spec/.*\.js$}
      end
      spec_files
    end
  end
end
