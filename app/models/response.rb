class Response < ActiveRecord::Base
  belongs_to :forum_thread
  belongs_to :user
  belongs_to :editor,     class_name: 'User',
                          foreign_key: 'edited_by'

  validates   :user_id,   presence: true
  validates   :user,      presence: true
  validates   :title,     presence: true
  validates   :content,   presence: true
end
# == Schema Information
#
# Table name: responses
#
#  id              :integer(4)      not null, primary key
#  forum_thread_id :integer(4)
#  title           :string(255)
#  content         :text
#  user_id         :integer(4)
#  edited_by       :integer(4)
#  created_at      :datetime
#  updated_at      :datetime
#

