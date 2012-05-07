class BugFacts < ActiveWarehouse::Dimension
  establish_connection "#{Rails.env}_warehouse"
end
# == Schema Information
#
# Table name: bug_facts
#
#  id        :integer(4)      not null, primary key
#  date_id   :integer(4)
#  bug_id    :integer(4)
#  type_id   :integer(4)
#  status_id :integer(4)
#

