# lib/json_web_token.rb
class JsonWebToken
  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, Rails.application.credentials.secret_key_base)
  end

  def self.decode(token)
    body = JWT.decode(token, Rails.application.credentials.secret_key_base)[0]
    HashWithIndifferentAccess.new(body) # Convert to HashWithIndifferentAccess for easier access
  rescue JWT::DecodeError => e
    raise JWT::DecodeError, e.message
  end
end
