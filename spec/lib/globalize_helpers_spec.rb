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
    t.string :foo
  end
end

class MyModel < ActiveRecord::Base
  translates :foo
  include GlobalizeHelpers
end

describe 'globalize helpers' do
  let!(:model) do
    I18n.with_locale(:ja) do
      MyModel.create!(:source_locale => 'ja', :foo => 'タイトル')
    end
  end
  before { I18n.locale = 'en' }
  after { I18n.locale = I18n.default_locale }

  describe '_in_source_locale methods' do
    it 'adds _in_source_locale methods to translated attributes' do
      Globalize.with_locale(:fr) do
        model.foo.should == nil
        model.foo_in_source_locale.should == 'タイトル'
      end
    end
  end

  describe 'nested translation accessors' do
    describe '#update_attributes' do
      let(:attr) { { 'foo' => { 'fr' => 'a new foo in French' } } }

      it 'replaces/adds translations based on nested values in JSON object' do
        Globalize.with_locale(:fr) { model.foo = 'a foo in French' }
        model.update_attributes(attr)
        Globalize.with_locale(:fr) { model.foo.should == 'a new foo in French' }
      end

      it 'leaves existing translations as is' do
        Globalize.with_locale(:fr) { model.foo = 'a foo in French' }
        Globalize.with_locale(:en) { model.foo = 'a foo in English' }
        model.update_attributes(attr)
        Globalize.with_locale(:en) { model.foo.should == 'a foo in English' }
      end

      pending 'assigns non-translated attributes with values in JSON object'

      it 'ignores nil attributes' do
        expect { model.update_attributes(nil) }.not_to raise_error
      end

      it 'does not assign nil-valued translated attributes' do
        Globalize.with_locale(:fr) { model.foo = 'a foo in French' }
        expect { model.update_attributes('foo' => nil) }.not_to raise_error
        Globalize.with_locale(:fr) { model.foo.should == 'a foo in French' }
      end
    end

    describe ".new" do
      let(:new_model) do
        attr = { "foo" =>  { "en" => "a foo in English",
                             "ja" =>  "a foo in Japanese" } }
        MyModel.new(attr)
      end

      it "assigns translated attributes defined as JSON objects" do
        Globalize.with_locale(:en) { new_model.foo.should == "a foo in English" }
        Globalize.with_locale(:ja) { new_model.foo.should == "a foo in Japanese" }
      end
    end
  end

  describe '#as_json' do
    it 'does not return nil translations' do
      model.as_json[:foo].should have_key('ja')
      model.as_json[:foo].should_not have_key('en')
    end
  end
end
