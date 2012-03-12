require 'spec_helper'

describe Bug do
  pending "add some examples to (or delete) #{__FILE__}"
end
# == Schema Information
#
# Table name: bugs
#
#  id                :integer(4)      not null, primary key
#  project_id        :integer(4)
#  status_id         :integer(4)
#  type_id           :integer(4)
#  priority_id       :integer(4)
#  short_description :string(255)
#  description       :text
#  commentary        :text
#  created_at        :datetime
#  updated_at        :datetime
#

