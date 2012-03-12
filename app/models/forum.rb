class Forum < ActiveRecord::Base
  belongs_to  :project
  belongs_to  :forum
  has_many    :forums,          dependent:   :destroy
  has_many    :forum_threads,   dependent:  :destroy

  # Ostatni poruszony wątek.
  #
  # @return [ForumThread] poruszony wątek
  def last_thread
    return @last_thread if @last_thread
    @last_thread = nil
    time = self.updated_at
    self.forum_threads.each do |thread|
      thread_time = thread.last_post
      if time < thread_time
        @last_thread = thread
        time = thread_time
      end
    end
    @last_thread
  end

  # Zwraca fora będące nadforami bieżącego.
  #
  # @return [array] nadfora
  def parents
    return @parents if @parents
    @parents = []
    parent = self.forum
    while parent
      @parents = [parent] + @parents
      parent = parent.forum
    end
    @parents
  end

  # Zwraca wszystkich możliwe nadfora.
  #
  # @return [array]  możliwe nadfora
  def possible_parents
    return @possible_parents if @possible_parents
    @possible_parents = Forum.all - [self] - subforums()
  end

  # Zwraca wszystkie możliwe podfora.
  #
  # @return [array] podfora
  def subforums
    return @subforums if @subforums
    @subforums = self.forums
    subforums = @subforums
    subforums.each do |forum|
      @subforums += forum.subforums
    end
    @subforums
  end
end
# == Schema Information
#
# Table name: forums
#
#  id          :integer(4)      not null, primary key
#  name        :string(255)
#  description :string(255)
#  forum_id    :integer(4)
#  project_id  :integer(4)
#  private     :boolean(1)
#  created_at  :datetime
#  updated_at  :datetime
#

