class Task < ApplicationRecord
  belongs_to :user
  validates_presence_of :title, :description, :due_date, :status
  enum status: { backlog: 0, in_progress: 1, done: 2 }

  scope :upcoming_tasks_to_remind_about, -> { where('deadline > ?', Time.now).where.not(state: 'Done') }

  def due_soon?(time_before)
    case time_before
    when '1 day'
      deadline - 1.day > Time.now && deadline - 1.day <= Time.now + 1.hour
    when '1 hour'
      deadline - 1.hour > Time.now && deadline - 1.hour <= Time.now + 1.hour
    else
      false
    end
  end
end
