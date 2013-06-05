# encoding: utf-8
require 'spec_helper'
require 'active_record'
require 'globalize'
require 'globalize_helpers'

ActiveRecord::Schema.define do
  create_table :my_models, :temporary => true do |t|
    t.string :source_locale
  end

  create_table :my_model_translations, :temporary => true do |t|
    t.references :my_model
    t.string :locale
    t.string :title
  end
end

class MyModel < ActiveRecord::Base
  translates :title
  include GlobalizeHelpers
end

describe 'globalize helpers' do
  before do
    I18n.with_locale(:ja) do
      @model = MyModel.create!(:source_locale => 'ja', :title => 'タイトル')
    end
  end

  it 'adds _in_source_locale methods to translated attributes' do
    Globalize.with_locale(:fr) do
      @model.title.should == nil
      @model.title_in_source_locale.should == 'タイトル'
    end
  end
end
