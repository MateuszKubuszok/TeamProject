class DateDimension < ActiveRecord::Base
  establish_connection  "#{Rails.env}_warehouse"
  set_table_name        'date_dimension'
end