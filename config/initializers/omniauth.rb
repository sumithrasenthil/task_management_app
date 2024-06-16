Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, '1061089247404-g9js8d4ad8t6sd6ra7a9f8082du3k0k1.apps.googleusercontent.com', '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', {
    scope: 'userinfo.email, userinfo.profile, calendar',
    prompt: 'consent',
    access_type: 'offline'
  }
end
