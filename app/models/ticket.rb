class Ticket < ActiveRecord::Base
  after_create :update_owner
  after_update :update_owner
  extend SymbolInteger

  # Tworzy akcesor status_types  przyjmujący symbol zamiast liczby
  define_symbols :status_types, [
    :new,
    :unaccepted,
    :reassigned,
    :reopened,
    :accepted,
    :resolved,
    :closed
  ]
  sym_accessor :status, :status_id, :status_types

  define_symbols :priority_types, {
     1 => :high,
     0 => :normal,
    -1 => :low
  }
  sym_accessor :priority, :priority_id, :priority_types

  belongs_to  :milestone
  belongs_to  :user

  validates   :name,      presence:   true
  validates   :status,    presence:   true
  validates   :priority,  presence:   true

  private

  # Aktualizuje updated_at właściciela.
  def update_owner
    self.milestone.save unless milestone.blank?
  end
end
# == Schema Information
#
# Table name: tickets
#
#  id           :integer(4)      not null, primary key
#  name         :string(255)
#  description  :string(255)
#  status_id    :integer(4)
#  priority_id  :integer(4)
#  milestone_id :integer(4)
#  user_id      :integer(4)
#  deadline     :date
#  created_at   :datetime
#  updated_at   :datetime
#

