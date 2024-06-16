class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[google_oauth2]

  has_many :tasks, dependent: :destroy

  # def self.from_omniauth(auth)
  #   where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
  #     user.email = auth.info.email
  #     user.password = Devise.friendly_token[0, 20]
  #     user.name = auth.info.name
  #   end.tap do |user|
  #     user.token = auth.credentials.token
  #     user.refresh_token = auth.credentials.refresh_token if auth.credentials.refresh_token.present?
  #     user.expires_at = Time.at(auth.credentials.expires_at)
  #     user.save
  #   end
  # end

  # def google_api_client
  #   client = Signet::OAuth2::Client.new(
  #     client_id: '1061089247404-g9js8d4ad8t6sd6ra7a9f8082du3k0k1.apps.googleusercontent.com',
  #     client_secret: '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',
  #     token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
  #     refresh_token: refresh_token
  #   )
  #   client.fetch_access_token! if client.expired?
  #   client
  # end
  
  # app/models/user.rb
def refresh_google_token
  client = Signet::OAuth2::Client.new({
    client_id: ENV['GOOGLE_CLIENT_ID'],
    client_secret: ENV['GOOGLE_CLIENT_SECRET'],
    token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
    refresh_token: self.refresh_token
  })
  response = client.refresh!

  update(
    token: response['access_token'],
    expires_at: Time.now + response['expires_in']
  )
end

def google_calendar_client
  # refresh_google_token if token_expired?
  client = Signet::OAuth2::Client.new(access_token: self.token)
  client
end

def token_expired?
  expires_at < Time.now
end

end
