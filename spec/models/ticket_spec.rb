require 'spec_helper'

describe Ticket do
  pending "add some examples to (or delete) #{__FILE__}"
end
# == Schema Information
#
# Table name: tickets
#
#  id          :integer(4)      not null, primary key
#  name        :string(255)
#  description :string(255)
#  status_id   :integer(4)
#  priority_id :integer(4)
#  user_id     :integer(4)
#  deadline    :date
#  created_at  :datetime
#  updated_at  :datetime
#

