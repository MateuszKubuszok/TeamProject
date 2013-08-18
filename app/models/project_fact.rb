class ProjectFact < ActiveRecord::Base
  establish_connection "#{Rails.env}_warehouse"
end