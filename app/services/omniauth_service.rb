# frozen_string_literal: true

class OmniauthService
  def self.from_omniauth(auth)
    return nil if auth.info&.email.nil?
    data = auth.info
    user = User.find_by(email: data[:email])
    name_user = auth[:provider] != "github" ? data[:name] : data[:nickname]
    if user.nil?
      new_password = Devise.friendly_token[0, 20]
      user = User.create!(
        name: name_user,
        email: data[:email],
        password: new_password,
        password_confirmation: new_password,
        activated: true,
        activated_at: Time.zone.now
      )
    end
    user
  end
end
