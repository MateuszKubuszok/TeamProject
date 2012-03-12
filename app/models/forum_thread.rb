class ForumThread < ActiveRecord::Base
  acts_as_taggable

  belongs_to  :forum
  belongs_to  :user
  belongs_to  :editor,    class_name: 'User',
                          foreign_key: 'edited_by'
  has_many    :responses, dependent: :destroy

  validates   :user_id,   presence: true
  validates   :user,      presence: true
  validates   :title,     presence: true
  validates   :content,   presence: true

  # Data wysłania ostatniego postu.
  #
  # @return [datetime]  data ostatniego postu
  def last_post_time
    return @last_post_time if @last_post_time
    last_post_author
    @last_post_time
  end

  # Autor ostatniego postu.
  #
  # @return [User]  autor ostatniego postu
  def last_post_author
    @last_post_author = self.user
    @last_post_time = self.updated_at
    self.responses.each do |response|
      if @last_post_time < response.updated_at
        @last_post_author = response.user
        @last_post_time = response.updated_at
      end
    end
    @last_post_author
  end
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

