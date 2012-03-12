require 'spec_helper'

describe ForumThread do
  pending "add some examples to (or delete) #{__FILE__}"
end
# == Schema Information
#
# Table name: forum_threads
#
#  id         :integer(4)      not null, primary key
#  forum_id   :integer(4)
#  title      :string(255)
#  content    :text
#  user_id    :integer(4)
#  edited_by  :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

