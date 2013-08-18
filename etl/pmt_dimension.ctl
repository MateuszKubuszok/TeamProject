require File.expand_path(File.absolute_path(File.dirname __FILE__) + '/../config/environment')
require 'fileutils'

in_db     = Rails.env
in_table  = Ticket.table_name

out_db    = "#{Rails.env}_warehouse"
out_table = PmtDimension.table_name

bulk_load_dir   = File.absolute_path(File.dirname __FILE__) + '/data'
bulk_load_file  = "#{bulk_load_dir}/#{out_table}.csv"
columns   = [ :date_id, :project, :milestone, :ticket, :project_name, :milestone_name, :ticket_name, :ticket_description, :ticket_priority_id, :ticket_priority, :private, :completed, :deadline, :date_pmt ]
separator = "\t"


# ekstrakcja
source :in, {
  type:   :database,
  target: in_db,
  table:  in_table,
  query: 'SELECT p.id AS `project`, m.id AS `milestone`, t.id AS `ticket`, p.name AS `project_name`, m.name AS `milestone_name`, t.name AS `ticket_name`, t.description AS `ticket_description`, t.priority_id AS `ticket_priority_id`, t.priority_id AS `ticket_priority`, p.private, t.status_id AS completed, SIGN(SIGN(DATEDIFF(CURDATE(),t.deadline))-1)+1 AS `deadline` FROM tickets t JOIN milestones m ON m.id=t.milestone_id JOIN projects p ON p.id=m.project_id'
}, columns


# ustawia date_id na datę w tabeli czasu określająca dzień dokonania zrzutu do hurtowni danych
date_id = DateDimension.find_by_sql_date_stamp(Date.today.to_s).id
transform(:date_id) { date_id }


# zapisuje w bazie nazwę danego typu
transform(:ticket_priority) { |name, value, row| Ticket.int2symbol(:priority_types, value.to_i).to_s }


# sprawdza czy tiken jest zakończony
minimum = Ticket.symbol2int :status_types, :resolved
transform(:completed) { |name, value, row| (minimum <= value.to_i) ? 1 : 0 }


# id do złączeń
transform(:date_pmt) { |name, value, row| "#{row[:date_id]}_#{row[:ticket]}" }


# zapis do pliku
FileUtils.makedirs bulk_load_dir
FileUtils.touch bulk_load_file
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