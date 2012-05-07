class TicketFacts < ActiveWarehouse::Fact
  establish_connection "#{Rails.env}_warehouse"
end
# == Schema Information
#
# Table name: ticket_facts
#
#  id          :integer(4)      not null, primary key
#  date_id     :integer(4)
#  ticket_id   :integer(4)
#  user_id     :integer(4)
#  status_id   :integer(4)
#  priority_id :integer(4)
#  deadline    :date
#

