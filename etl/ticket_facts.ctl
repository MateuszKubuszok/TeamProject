require File.expand_path(File.dirname(__FILE__) + '/../config/environment')

in_db     = Rails.env
in_table  = Ticket.table_name

out_db    = "#{Rails.env}_warehouse"
out_table = TicketFacts.table_name

bulk_load_file = "data/#{out_table}.csv"
columns   = [ :date_id, :ticket_id, :user_id, :status_id, :priority_id, :deadline ]
separator = "\t"


# ekstrakcja
source :in, {
  type:   :database,
  target: in_db,
  table:  in_table,
  select: 'CURDATE() as `date_id`, tickets.id AS `ticket_id`, tickets.user_id, tickets.status_id, tickets.priority_id, tickets.deadline'
}, [
  :date_id,
  :ticket_id,
  :user_id,
  :status_id,
  :priority_id,
  :deadline
]


# zamienia datę w date_id na odpowiadający jej id w wymiarze daty
date_id = DateDimension.find_by_sql_date_stamp(Date.today.to_s).id
transform(:date_id) do
  date_id
end


# zapis do pliku
destination :out, {
  file:       bulk_load_file,
  separator:  separator
}, {
  order: columns
}


# zapis z pliku do bazy
post_process :bulk_import, {
  file:             bulk_load_file,
  columns:          columns,
  truncate:         false,
  field_separator:  separator,
  target:           out_db,
  table:            out_table
}