class Response < ActiveRecord::Base
  after_create :update_owner
  after_update :update_owner

  belongs_to :forum_thread
  belongs_to :user
  belongs_to :editor,     class_name: 'User',
                          foreign_key: 'edited_by'

  validates   :user_id,   presence: true
  validates   :user,      presence: true
  validates   :title,     presence: true
  validates   :content,   presence: true

  private

  # Aktualizuje updated_at właściciela.
  def update_owner
    self.forum_thread.save unless forum_thread.blank?
  end
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

