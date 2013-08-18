class BugFact < ActiveRecord::Base
 establish_connection "#{Rails.env}_warehouse"
end