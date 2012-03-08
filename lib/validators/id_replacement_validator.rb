# Sprawdza, czy pole może zastąpić id (nie jest liczbą całkowitą).
#
# Przykład:
#   validates :field, :id_replacement => true
class IdReplacementValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors[attribute] << (options[:message] ? options[:message] : "cannot be an integer") if /\A[0-9]*\Z/.match value.to_s
    record.errors[attribute] << (options[:message] ? options[:message] : "cannot be 'new'") if 'new'.eql? value
  end
end