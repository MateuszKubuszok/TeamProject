class UserDimension < ActiveRecord::Base
  establish_connection  "#{Rails.env}_warehouse"
  set_table_name        'user_dimension'
end