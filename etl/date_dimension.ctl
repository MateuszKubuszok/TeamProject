require File.expand_path(File.absolute_path(File.dirname __FILE__) + '/../config/environment')
require 'fileutils'

out_db          = "#{Rails.env}_warehouse"
out_table       = DateDimension.table_name

bulk_load_dir   = File.absolute_path(File.dirname __FILE__) + '/data'
bulk_load_file  = "#{bulk_load_dir}/#{out_table}.csv"

start_date      = Date.parse('2000-01-01')
end_date        = Date.parse('2020-01-01')

# czyści tablicę dat
pre_process :truncate, {
  target: out_db,
  table:  out_table
}


# ekstrakcja
records = ETL::Builder::DateDimensionBuilder.new(start_date, end_date).build
source :in, {
  type:           :enumerable,
  enumerable:     records,
  store_locally:  false
}

# wczytaj kolumny z pierwszego rekordu
columns = records.first.keys

# wczytaj tylko nowe rekordy pred załadowaniem
FileUtils.makedirs bulk_load_dir
FileUtils.touch bulk_load_file
destination :out, {
  file: bulk_load_file
}, {
  order: columns
}

# załaduj plik do bazy
post_process :bulk_import, {
  file:     bulk_load_file,
  columns:  columns,
  target:   out_db,
  table:    out_table
}

after_post_process_screen(:fatal) do
  assert_equal end_date - start_date + 1, DateDimension.count

  # zapewnijmy stałość id pomimo czyszczenia bazy
  assert_equal start_date, DateDimension.find(1).sql_date_stamp
end