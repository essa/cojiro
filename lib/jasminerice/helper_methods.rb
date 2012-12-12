require "requirejs-rails"

module Jasminerice
  module HelperMethods
    def self.included(base)
      base.class_eval do
        helper RequirejsHelper
        helper SpecFileHelper
      end
    end

  end
end

module SpecFileHelper
  def spec_files
    spec_files = []
    env = Rails.application.assets
    env.each_logical_path do |lp|
      spec_files << lp if lp =~ %r{^spec/.*\.js$}
    end
    spec_files
  end
end
