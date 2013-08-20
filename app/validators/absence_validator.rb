# until we upgrade to rails 4, we'll need this
class AbsenceValidator < ActiveModel::EachValidator
  def validate_each(record, attr_name, value)
    record.errors.add(attr_name, :present, options) if value.present?
  end
end
