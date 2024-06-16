class Task < ApplicationRecord
  belongs_to :user
  validates_presence_of :title, :description, :due_date, :status
  enum status: { backlog: 0, in_progress: 1, done: 2 }

  scope :upcoming_tasks_to_remind_about, -> { where('due_date > ?', Time.now).where.not(status: 'done') }

  after_create :add_to_google_calendar

  def add_to_google_calendar
    GoogleCalendarService.new(user).create_event(self)
  end
  
  def due_soon?(time_before)
    case time_before
    when '1 day'
      due_date - 1.day > Time.now && due_date - 1.day <= Time.now + 1.hour
    when '1 hour'
      due_date - 1.hour > Time.now && due_date - 1.hour <= Time.now + 1.hour
    else
      false
    end
  end
end
