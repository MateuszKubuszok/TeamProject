class ProjectDimension < ActiveRecord::Base
  establish_connection  "#{Rails.env}_warehouse"
  set_table_name        'project_dimension'
end