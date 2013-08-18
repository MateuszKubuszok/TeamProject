class PmtDimension < ActiveRecord::Base
  establish_connection  "#{Rails.env}_warehouse"
  set_table_name        'pmt_dimension'
end