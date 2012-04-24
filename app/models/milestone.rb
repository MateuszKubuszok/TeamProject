class Milestone < ActiveRecord::Base
  after_create :update_owner
  after_update :update_owner

  belongs_to  :project
  has_many    :tickets,     dependent:  :destroy

  validates   :name,        presence:   true
  validates   :project_id,  presence:   true
  validates   :project,     presence:   true

  # Zwraca procent w jakim jest ukończony dany milestone (% zamkniętych ticketów)).
  #
  # @return [float]
  def completion
    return @completion if defined? @completion
    result = ActiveRecord::Base.connection.execute("SELECT closed, all_tickets FROM
                                                    (SELECT COUNT(*) AS 'all_tickets' FROM tickets t WHERE t.milestone_id = #{self.id}) AS s1,
                                                    (SELECT COUNT(*) AS 'closed' FROM tickets t2 WHERE t2.milestone_id = #{self.id} AND t2.status_id = #{Ticket.symbol2int :status_types, :closed}) AS s2")
    result.each { |closed, all| @completion = (all == 0 ? 100.0 : closed.to_f/all.to_f*100.0) }
    @completion
  end

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
    @ticket = @deadline = nil
    result = ActiveRecord::Base.connection.execute("SELECT t.id as last_ticket, MAX(t.deadline) as deadline FROM tickets t WHERE t.milestone_id = #{self.id} LIMIT 1")
    result.each do |id,deadline|
      @ticket = Ticket.find_by_id id
      @deadline = deadline
    end
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

