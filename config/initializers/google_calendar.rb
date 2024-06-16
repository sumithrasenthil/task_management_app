# require 'google/apis/calendar_v3'
# require 'google/api_client/client_secrets'



# config/initializers/google_calendar.rb

GOOGLE_CLIENT_ID = '1061089247404-g9js8d4ad8t6sd6ra7a9f8082du3k0k1.apps.googleusercontent.com '
GOOGLE_CLIENT_SECRET = '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'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, GOOGLE_CLIENT_ID, GOOGLE_CLIENT_SECRET, {
    scope: 'https://www.googleapis.com/auth/calendar',
    prompt: 'consent'
  }
end
