require 'config/environment'

case Rails.env
  when :development
    outfile = 'data/development_ticket_facts.txt'
  when :test
    outfile = 'data/test_ticket_facts.txt'
  else
    outfile = 'data/production_ticket_facts.txt'
end

in_db     = Rails.env
in_table  = :tickets

out_db    = "#{Rails.env}_warehouse"
out_table = :ticket_facts

columns   = [ :time_id, :ticket_id, :user_id, :status, :priority, :deadline ]
separator = "\t"


# ekstrakcja
source :in, {
  type:   :database,
  target: in_db,
  table:  in_table,
  select: 'tickets.id AS `ticket_id`, ticket.user_id, tickets.status_id AS `status`, ticket.priority_id AS `priority`, ticket.deadline'
}, [
  :time_id,
  :ticket_id,
  :user_id,
  :status,
  :priority,
  :deadline
]


# miejsce na transformacje
transform :time_id, :foreign_key_lookup, {
  resolver: ActiveRecordResolver.new(
    DateDimension, :find_by_sql_date_stamp
  )
}


# zapis do pliku
destination :out, {
  file:       outfile,
  separator:  separator
}, {
  order: columns,
  virtual: {
    time_id: ETL::Generator::SurrogateKeyGenerator.new(
      :query => 'SELECT MAX(id) FROM time_dimension'
    )
  }
}


# zapis z pliku do bazy
post_process :bulk_import, {
  file:             outfile,
  columns:          columns,
  truncate:         false,
  field_separator:  separator,
  target:           out_db,
  table:            out_table
}