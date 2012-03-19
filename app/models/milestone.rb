class Milestone < ActiveRecord::Base
  belongs_to  :project
  has_many    :tickets,     dependent:  :destroy

  validates   :name,        presence:   true
  validates   :project_id,  presence:   true
  validates   :project,     presence:   true

  # Zwraca deadline.
  #
  # @return [datetime] ostatni deadline
  def last_deadline
    return @deadline if @deadline
    last_ticket
    @deadline
  end

  # Zwraca najpóźniejszy ticket.
  #
  # @return [Ticket] najpóźniejszy ticket
  def last_ticket
    return @ticket if @ticket
    @ticket = nil
    @deadline = self.created_at.to_date
    self.tickets.each do |ticket|
      if ticket.deadline > @deadline
        @ticket = ticket
        @deadline = ticket.deadline
      end
    end
    @deadline = nil if @ticket.nil?
    @ticket
  end
end
# == Schema Information
#
# Table name: milestones
#
#  id          :integer(4)      not null, primary key
#  name        :string(255)
#  description :text
#  project_id  :integer(4)
#  created_at  :datetime
#  updated_at  :datetime
#

