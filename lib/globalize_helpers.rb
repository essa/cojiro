require 'globalize'

module GlobalizeHelpers
  def self.included(klass)
    klass.translated_attribute_names.each do |attr|
      define_method("#{attr}_in_source_locale") do
        read_attribute attr, { :locale => source_locale }
      end
    end
  end
end
