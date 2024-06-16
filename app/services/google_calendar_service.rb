# app/services/google_calendar_service.rb
require 'google/apis/calendar_v3'
require 'googleauth'
require 'googleauth/stores/file_token_store'


class GoogleCalendarService
  def initialize(user)
    @client = Google::Apis::CalendarV3::CalendarService.new
    @client.authorization = user.google_calendar_client
  end

  def create_event(task)
    event = Google::Apis::CalendarV3::Event.new(
      summary: task.title,
      description: task.description,
      start: Google::Apis::CalendarV3::EventDateTime.new(
        date_time: task.due_date.iso8601
      ),
      end: Google::Apis::CalendarV3::EventDateTime.new(
        date_time: (task.due_date + 1.hour).iso8601
      )
    )
    @client.insert_event('primary', event)
  end
end
