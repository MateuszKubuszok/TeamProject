class BugDimension < ActiveRecord::Base
  establish_connection  "#{Rails.env}_warehouse"
  set_table_name        'bug_dimension'
end