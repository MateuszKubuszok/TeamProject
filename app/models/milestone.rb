class Milestone < ActiveRecord::Base
  after_create :update_owner
  after_update :update_owner

  belongs_to  :project
  has_many    :tickets,     dependent:  :destroy

  validates   :name,        presence:   true
  validates   :project_id,  presence:   true
  validates   :project,     presence:   true

  # Zwraca deadline.
  #
  # @return [datetime] ostatni deadline
  def last_deadline
    return @deadline if defined? @deadline
    last_ticket
    @deadline
  end

  # Zwraca najpóźniejszy ticket.
  #
  # @return [Ticket] najpóźniejszy ticket
  def last_ticket
    return @ticket if defined? @ticket
    @ticket = nil
    @deadline = self.created_at.to_date
    @change = self.updated_at
    self.tickets.each do |ticket|
      if ticket.deadline > @deadline
        @ticket = ticket
        @deadline = ticket.deadline
      end
      @change = @change > ticket.updated_at ? @change : ticket.updated_at
    end
    @deadline = nil if @ticket.nil?
    @ticket
  end

  # Ostatnia zmiana w milestonie/jego ticketach.
  #
  # @return [datetime] najpóźniejsza zmiana
  def last_change
    return @change if defined? @change
    last_ticket
    @change
  end

  private

  # Aktualizuje updated_at właściciela.
  def update_owner
    self.project.save unless project.blank?
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

