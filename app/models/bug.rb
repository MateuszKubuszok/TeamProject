class Bug < ActiveRecord::Base
  extend SymbolInteger

  define_symbols :status_types, [
    :new,
    :unaccepted,
    :reassigned,
    :reopened,
    :accepted,
    :resolved,
    :closed
  ]
  sym_accessor :status, :status_id, :status_types

  define_symbols :type_types, [
    :bug,
    :fatal_error,
    :enhancement,
    :feature
  ]
  sym_accessor :type, :type_id, :type_types

  define_symbols :priority_types, {
     1 => :high,
     0 => :normal,
    -1 => :low
  }
  sym_accessor :priority, :priority_id, :priority_types

  belongs_to :project
end
