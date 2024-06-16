# app/services/google_calendar_service.rb

require 'google/apis/calendar_v3'
require 'googleauth'

class GoogleCalendarService
  def initialize(user)
    @user = user
    @service = Google::Apis::CalendarV3::CalendarService.new
    @service.authorization = user.google_oauth2_token
  end

  def create_event(event_params)
    calendar_id = 'primary'  # 'primary' is the default calendar for the authenticated user
    event = Google::Apis::CalendarV3::Event.new(event_params)
    @service.insert_event(calendar_id, event)
  end

  def update_event(event_id, event_params)
    calendar_id = 'primary'
    event = Google::Apis::CalendarV3::Event.new(event_params)
    @service.update_event(calendar_id, event_id, event)
  end

  def delete_event(event_id)
    calendar_id = 'primary'
    @service.delete_event(calendar_id, event_id)
  end
end
