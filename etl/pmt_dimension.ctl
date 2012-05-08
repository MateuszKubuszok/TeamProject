require File.expand_path(File.dirname(__FILE__) + '/../config/environment')

in_db     = Rails.env
in_table  = Ticket.table_name

out_db    = "#{Rails.env}_warehouse"
out_table = 'pmt_dimension'

bulk_load_file = "data/#{out_table}.csv"
columns   = [ :date_id, :project, :milestone, :ticket, :project_name, :milestone_name, :ticket_name, :ticket_description, :private ]
separator = "\t"


# ekstrakcja
source :in, {
  type:   :database,
  target: in_db,
  table:  in_table,
  query: 'SELECT p.id AS `project`, m.id AS `milestone`, t.id AS `ticket`, p.name AS `project_name`, m.name AS `milestone_name`, t.name AS `ticket_name`, t.description AS `ticket_description`, p.private FROM tickets t JOIN milestones m ON m.id=t.milestone_id JOIN projects p ON p.id=m.project_id'
}, columns


# ustawia date_id na datę w tabeli czasu określająca dzień dokonania zrzutu do hurtowni danych
date_id = DateDimension.find_by_sql_date_stamp(Date.today.to_s).id
transform(:date_id) { date_id }


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