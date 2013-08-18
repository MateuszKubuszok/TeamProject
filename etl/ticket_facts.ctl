require File.expand_path(File.absolute_path(File.dirname __FILE__) + '/../config/environment')
require 'fileutils'

in_db     = Rails.env
in_table  = Ticket.table_name

out_db    = "#{Rails.env}_warehouse"
out_table = TicketFact.table_name

bulk_load_dir   = File.absolute_path(File.dirname __FILE__) + '/data'
bulk_load_file  = "#{bulk_load_dir}/#{out_table}.csv"
columns   = [ :date_id, :ticket_id, :user_id, :till_deadline, :date_pmt, :date_user ]
separator = "\t"


# ekstrakcja
source :in, {
  type:   :database,
  target: in_db,
  table:  in_table,
  select: 'tickets.id AS `ticket_id`, tickets.user_id, DATEDIFF(tickets.deadline,CURDATE()) AS `till_deadline`'
}, columns


# ustawia date_id na datę w tabeli czasu określająca dzień dokonania zrzutu do hurtowni danych
date_id = DateDimension.find_by_sql_date_stamp(Date.today.to_s).id
transform(:date_id) { date_id }


# id do złączeń
transform(:date_pmt)  { |name, value, row| "#{row[:date_id]}_#{row[:ticket_id]}" }
transform(:date_user) { |name, value, row| "#{row[:date_id]}_#{row[:user_id]}" }


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
