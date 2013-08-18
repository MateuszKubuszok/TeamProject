class TicketFact < ActiveRecord::Base
  establish_connection "#{Rails.env}_warehouse"
end