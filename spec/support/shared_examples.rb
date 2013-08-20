# assumes model is defined in let block
shared_examples_for 'attribute with locale methods' do |attr_name|
  it "has #{attr_name}_in_source_locale method" do
    value = 'attribute in source locale'
    Globalize.with_locale(model.source_locale) do
      model.public_send(attr_name + '=', value)
    end
    Globalize.with_locale('xx') do
      model.send(attr_name).should == nil
      model.send("#{attr_name}_in_source_locale").should == value
    end
  end
end

shared_examples_for 'attribute with nested translation accessors' do |attr_name|
  it 'replaces/adds translations based on nested values in JSON object' do
    attr = { attr_name => { 'xx' => 'a new attribute in a locale' } }
    Globalize.with_locale(:xx) { model.public_send("#{attr_name}=", 'an attribute in a locale') }
    model.update_attributes(attr)
    Globalize.with_locale(:xx) { model.send(attr_name).should == 'a new attribute in a locale' }
  end
end
