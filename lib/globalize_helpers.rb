require 'globalize'

module GlobalizeHelpers
  def self.included(klass)
    klass.translated_attribute_names.each do |attr|
      define_method("#{attr}_in_source_locale") do
        read_attribute attr, { :locale => source_locale }
      end
    end

    def write_attribute(name, value, options = {})
      if translated?(name) && value.is_a?(Hash)
        send("#{name}_translations=", value)
      else
        super(name, value, options)
      end
    end

    def merge_translations!(source)
      source.translated_attribute_names.each do |attr|
        send("#{attr}_translations=", source.send("#{attr}_translations"))
      end
    end

    def serializable_hash(options = {})
      hash = super(options)
      translated_attribute_names.each do |attr|
        translations = send("#{attr}_translations").delete_if { |_,v| v.nil? }
        hash.merge!(attr.to_s => translations)
      end
      hash
    end
  end
end
