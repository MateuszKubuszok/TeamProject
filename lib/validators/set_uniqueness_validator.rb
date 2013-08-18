# Sprawdza, czy zachodzi unikalność zestawu pól.
#
# Przykład:
#   validates :field, :set_uniqueness => [ field1, field2 ]
#
# Sprawdzi, czy istniej już rekord, którym istnieją takie same wartości jak w odpowiedznich polach :field1, :field2.
# Jeśli tak jest, zwroci błąd dla pola :field.
class SetUniquenessValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    setup record
    record.errors[attribute] << (options[:message] ? options[:message] : "- collection of fields [" + @fields + "] is not unique") if record.id.nil? && record.class.count(:conditions => @conditions) > 0
  end

  def check_validity!
    raise ArgumentError, "Must contain an array of field names' symbols" unless options[:in] && options[:in].respond_to?(:each)
  end

  private

  def setup record
    conditions  = []
    fields      = []

    options[:in].each do |field|
      conditions  |= [ field.to_s + " = '" + record[field].to_s + "'" ]
      fields      |= [ field.to_s ]
    end

    @conditions = conditions.join(" AND ")
    @fields     = fields.join(", ")
  end
end