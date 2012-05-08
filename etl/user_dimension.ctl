require File.expand_path(File.dirname(__FILE__) + '/../config/environment')

in_db     = Rails.env
in_table  = User.table_name

out_db    = "#{Rails.env}_warehouse"
out_table = 'user_dimension'

bulk_load_file = "data/#{out_table}.csv"
columns   = [ :date_id, :user_id, :login, :name, :surname, :about_me, :www, :email ]
separator = "\t"


# ekstrakcja
source :in, {
  type:   :database,
  target: in_db,
  table:  in_table,
  select: 'users.id AS `user_id`, users.login, users.name, users.surname, users.about_me, users.www, users.email'
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