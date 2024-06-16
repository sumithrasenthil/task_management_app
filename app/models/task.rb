require 'google/apis/calendar_v3'
require 'googleauth'
class Task < ApplicationRecord
  belongs_to :user
  validates_presence_of :title, :description, :due_date, :status
  enum status: { backlog: 0, in_progress: 1, done: 2 }

  scope :upcoming_tasks_to_remind_about, -> { where('due_date > ?', Time.now).where.not(status: 'done') }

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

  after_create :sync_to_google_calendar
  after_update :update_google_calendar_event
  after_destroy :delete_from_google_calendar

  private

  def sync_to_google_calendar
    # Prepare event parameters
    event_params = {
      summary: self.title,
      description: self.description,
      start: {
        date_time: self.due_date.in_time_zone.rfc3339,
        time_zone: self.due_date.time_zone.name
      },
      end: {
        date_time: self.due_date.in_time_zone.rfc3339,
        time_zone: self.due_date.time_zone.name
      }
    }

    # Create event on Google Calendar
    GoogleCalendarService.new(user).create_event(event_params)
  end

  def update_google_calendar_event
    # Assuming you have a calendar_event_id stored in your Task model
    if calendar_event_id.present?
      event_params = {
        summary: self.title,
        description: self.description,
        start: {
          date_time: self.due_date.in_time_zone.rfc3339,
          time_zone: self.due_date.time_zone.name
        },
        end: {
          date_time: self.due_date.in_time_zone.rfc3339,
          time_zone: self.due_date.time_zone.name
        }
      }

      # Update event on Google Calendar
      GoogleCalendarService.new(user).update_event(calendar_event_id, event_params)
    else
      # Handle case where calendar_event_id is missing
      Rails.logger.error("Calendar event ID missing for task #{self.id}")
    end
  end

  def delete_from_google_calendar
    # Delete event from Google Calendar
    if calendar_event_id.present?
      GoogleCalendarService.new(user).delete_event(calendar_event_id)
    else
      # Handle case where calendar_event_id is missing
      Rails.logger.error("Calendar event ID missing for task #{self.id}")
    end
  end

  # Method to retrieve the calendar_event_id (assuming it's stored in your Task model)
  def calendar_event_id
    # Implement as per your application's logic
    self.calendar_event_id # Replace with your actual attribute name
  end
end
